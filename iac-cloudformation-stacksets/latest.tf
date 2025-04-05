locals {
  all_ous_latest = [
    "r-b3bx"
  ]

  tagging_assume_role_stacksets_latest = {
    "tagging-assume-role-stacksets-latest" = {
      enabled = true
      settings = {
        description             = "Assume Role StackSets"
        template_file_name      = "stackset-templates/tg-assume-role-stackset.yml"
        organizational_unit_ids = local.all_ous_latest
        account_ids             = [984505168843]
        account_filter_type     = "INTERSECTION"
      }
    }
  }

  tagging_aws_config_config_rule_stacksets_latest = {
    "tagging-aws-config-config-rule-stacksets-latest" = {
      enabled = true
      settings = {
        regions = ["us-east-1",
          "us-west-2",
          "us-west-1",
          "us-east-2",
        ]
        account_ids         = [984505168843]
        account_filter_type = "INTERSECTION"

        description             = "Tagging Configuration StackSets"
        template_file_name      = "stackset-templates/tg-aws-config-rules-stackset.yml"
        failure_tolerance_count = 1
        max_concurrent_count    = 1
        organizational_unit_ids = local.all_ous_latest
      }
    }
  }

  tagging_custom_lambda_stackset_latest = {
    "tagging-custom-lambda-stackset-latest" = {
      enabled = true
      settings = {
        regions = ["us-east-1",
          "us-west-2",
          "us-west-1",
          "us-east-2",
        ]
        account_ids         = [984505168843]
        account_filter_type = "INTERSECTION"

        description             = "Tagging Custom Lambda StackSet"
        template_file_name      = "stackset-templates/tg-custom-lambda-stackset.yml"
        failure_tolerance_count = 1
        max_concurrent_count    = 1
        organizational_unit_ids = local.all_ous_latest
      }
    }
  }

}