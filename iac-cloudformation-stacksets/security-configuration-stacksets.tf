locals {
  
  all_ous = [
    "r-b3bx"
  ]

  tagging_aws_config_config_rule_stacksets = {
    "tagging-aws-config-config-rule-stacksets" = {
      enabled = true
      settings = {
        regions = ["us-east-1",
           "us-west-2",
           "us-west-1",
           "us-east-2",         
        ]
        account_ids = [438465163349]
        account_filter_type = "INTERSECTION"

        description = "Tagging Configuration StackSets"
        template_file_name = "stackset-templates/aws-config-config-rules-stacksets.yml"
        failure_tolerance_count = 1
        max_concurrent_count = 1
        organizational_unit_ids = local.all_ous
      }
    }
  }

  tagging_custom_lambda_stackset = {
    "tagging-custom-lambda-stackset" = {
      enabled = true
      settings = {
        regions = ["us-east-1",
           "us-west-2",
           "us-west-1",
           "us-east-2",         
        ]
        account_ids = [438465163349]
        account_filter_type = "INTERSECTION"

        description = "Tagging Custom Lambda StackSet"
        template_file_name = "stackset-templates/custom-lambda-stackset.yml"
        failure_tolerance_count = 1
        max_concurrent_count = 1
        organizational_unit_ids = local.all_ous
      }
    }
  }
}