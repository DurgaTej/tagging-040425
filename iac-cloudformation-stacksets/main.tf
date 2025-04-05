module "cf_stacksets-role" {
  for_each = { for k, v in local.tagging_assume_role_stacksets_latest : k => v if v.enabled }
  source   = "./modules/cloudformation"

  name     = each.key
  settings = each.value.settings
}

module "cf_stacksets-lambda" {
  for_each = { for k, v in local.tagging_custom_lambda_stackset_latest : k => v if v.enabled }
  source   = "./modules/cloudformation"

  name       = each.key
  settings   = each.value.settings
  depends_on = [module.cf_stacksets-role]
}

module "cf_stacksets-config-rule" {
  for_each = { for k, v in local.tagging_aws_config_config_rule_stacksets_latest : k => v if v.enabled }
  source   = "./modules/cloudformation"

  name       = each.key
  settings   = each.value.settings
  depends_on = [module.cf_stacksets-lambda]
}