import json
import boto3
import os

# Allowed values for the "mmsystem" tag
ALLOWED_VALUES = {"finance", "hr", "it", "marketing", "sales"}

config_client = boto3.client("config")
tagging_client = boto3.client("resourcegroupstaggingapi")


def lambda_handler(event, context):
    print("Received event:", json.dumps(event))

    invoking_event = json.loads(event["invokingEvent"])
    configuration_item = invoking_event["configurationItem"]

    resource_id = configuration_item["resourceId"]
    resource_type = configuration_item["resourceType"]

    compliance_type = "COMPLIANT"
    mm_compliance_value = "compliant" #default value.

    # Check if the resource has tags
    tags = configuration_item.get("tags", {})

    if "mmsystem" not in tags:
        compliance_type = "NON_COMPLIANT"
        annotation = "Missing required 'mmsystem' tag."
        mm_compliance_value = "non-compliant: missing mmsystem"
    elif tags["mmsystem"] not in ALLOWED_VALUES:
        compliance_type = "NON_COMPLIANT"
        annotation = f"Invalid 'mmsystem' value: {tags['mmsystem']}. Allowed values: {', '.join(ALLOWED_VALUES)}."
        mm_compliance_value = f"non-compliant: invalid mmsystem value {tags['mmsystem']}"
    else:
        annotation = "'mmsystem' tag is present and valid."

    # Report compliance status to AWS Config
    response = config_client.put_evaluations(
        Evaluations=[
            {
                "ComplianceResourceType": resource_type,
                "ComplianceResourceId": resource_id,
                "ComplianceType": compliance_type,
                "Annotation": annotation,
                "OrderingTimestamp": configuration_item["configurationItemCaptureTime"],
            }
        ],
        ResultToken=event["resultToken"],
    )

    # Add the mmcompliance tag
    try:
        tagging_client.tag_resources(
            ResourceARNList=[resource_id],
            Tags=[
                {
                    "Key": "mmcompliance",
                    "Value": mm_compliance_value,
                }
            ],
        )
        print(f"Added mmcompliance tag with value: {mm_compliance_value}")
    except Exception as e:
        print(f"Error adding mmcompliance tag: {e}")

    return response