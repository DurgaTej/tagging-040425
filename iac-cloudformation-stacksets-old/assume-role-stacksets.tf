locals {
  assume_role_stacksets = {
    "assume-role-stacksets" = {
      enabled = true
      settings = {
        description = "Assume Role StackSets"
        template_file_name = "stackset-templates/assume-role-stacksets.yml"
        organizational_unit_ids = local.all_ous
        account_ids = [984505168843, 438465163349]
        account_filter_type = "INTERSECTION"
    }
    }
  }
}