locals {
    all_ous1 = [
        "r-b3bx"
    ]

    tagging_stacksets = {
        "tagging-stacksets" = {
        enabled = true
        settings = {
            regions = ["us-east-1",
            "us-west-2",
            "us-west-1",
            "us-east-2",         
            ]
            account_ids = [984505168843]
            account_filter_type = "INTERSECTION"

            description = "Tagging StackSets"
            template_file_name = "stackset-templates/tagging-stacksets.yml"
            failure_tolerance_count = 1
            max_concurrent_count = 1
            organizational_unit_ids = local.all_ous1
        }
        }
    }
}