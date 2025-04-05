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
    resource_arn = configuration_item.get("ARN") or build_arn(configuration_item)

    compliance_type = "COMPLIANT"
    mm_compliance_value = "compliant"  # default value

    # Check if the resource has tags
    tags = configuration_item.get("tags", {})

    if "mmsystem" not in tags:
        compliance_type = "NON_COMPLIANT"
        annotation = "Missing required 'mmsystem' tag."
        mm_compliance_value = "non-compliant: missing mmsystem"
    elif tags["mmsystem"] not in ALLOWED_VALUES:
        compliance_type = "NON_COMPLIANT"
        annotation = (
            f"Invalid 'mmsystem' value: {tags['mmsystem']}. "
            f"Allowed values: {', '.join(sorted(ALLOWED_VALUES))}."
        )
        mm_compliance_value = f"non-compliant: invalid mmsystem value {tags['mmsystem']}"
    else:
        annotation = "'mmsystem' tag is present and valid."

    # Report compliance status to AWS Config
    try:
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
        print(f"Compliance reported: {compliance_type}")
    except Exception as e:
        print(f"Error reporting compliance: {e}")
        raise

    # Add the mmcompliance tag
    try:
        tagging_client.tag_resources(
            ResourceARNList=[resource_arn],
            Tags={"mmcompliance": mm_compliance_value},
        )
        print(f"Tagged {resource_arn} with mmcompliance = {mm_compliance_value}")
    except Exception as e:
        print(f"Error tagging resource: {e}")

    return response


def build_arn(configuration_item):
    """
    Builds an ARN from a configuration item if not present. This is a fallback and works only for basic resources.
    Customize for your specific services.
    """
    region = os.environ.get("AWS_REGION", "us-east-1")
    account_id = configuration_item["awsAccountId"]
    resource_type = configuration_item["resourceType"]
    resource_id = configuration_item["resourceId"]

    if resource_type == "AWS::S3::Bucket":
        return f"arn:aws:s3:::{resource_id}"
    elif resource_type.startswith("AWS::EC2::"):
        return f"arn:aws:ec2:{region}:{account_id}:{resource_id}"
    elif resource_type == "AWS::IAM::Role":
        return f"arn:aws:iam::{account_id}:role/{resource_id}"
    else:
        # Generic fallback
        return f"arn:aws:unknown:{region}:{account_id}:{resource_type}/{resource_id}"
