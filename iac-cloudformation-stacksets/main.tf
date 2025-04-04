module "cf_stacksets" {
    for_each = { for k, v in local.tagging_stacksets : k=> v if v.enabled }
    source = "./modules/cloudformation"

    name = each.key
    settings = each.value.settings
}