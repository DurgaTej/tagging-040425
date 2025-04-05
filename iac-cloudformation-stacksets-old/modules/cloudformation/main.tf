resource "aws_cloudformation_stack_set" "this" {
    name = var.name
    auto_deployment {
        enabled = true
        retain_stacks_on_account_removal = false
    }
    description = var.settings.description
    capabilities = var.settings.capabilities
    parameters = var.settings.parameters
    permission_model = var.settings.permission_model
    call_as = "DELEGATED_ADMIN"
    template_body = file(var.settings.template_file_name)
    operation_preferences {
        failure_tolerance_count = var.settings.failure_tolerance_count
        max_concurrent_count = var.settings.max_concurrent_count
        region_concurrency_type = var.settings.region_concurrency_type
    }

    tags = var.settings.tags
}

resource "aws_cloudformation_stack_set_instance" "this" {
    for_each = toset(var.settings.regions)

    stack_set_name = aws_cloudformation_stack_set.this.name
    region = each.key

    deployment_targets {
      organizational_unit_ids = var.settings.organizational_unit_ids
      accounts = var.settings.account_ids
      account_filter_type = var.settings.account_filter_type
    }
    call_as = "DELEGATED_ADMIN"
    operation_preferences {
        failure_tolerance_count = var.settings.failure_tolerance_count
        max_concurrent_count = var.settings.max_concurrent_count
        region_concurrency_type = var.settings.region_concurrency_type
    }
    
}