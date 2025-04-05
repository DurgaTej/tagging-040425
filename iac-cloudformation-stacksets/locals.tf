locals {
  stacksets-role = merge(
    local.tagging_aws_config_config_rule_stacksets_latest,
    local.tagging_custom_lambda_stackset_latest,
    local.tagging_assume_role_stacksets_latest
  )
}