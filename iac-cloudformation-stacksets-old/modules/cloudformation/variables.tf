variable "settings" {
  type = object({
    description                 = optional(string)
    capabilities                = optional(list(string), ["CAPABILITY_NAMED_IAM"])
    parameters                  = optional(map(string))
    permission_model            = optional(string, "SERVICE_MANAGED")
    template_file_name          = any
    failure_tolerance_count     = optional(number, 1)
    max_concurrent_count        = optional(number, 1)
    region_concurrency_type     = optional(string, "PARALLEL")
    regions                     = optional(list(string), ["us-east-1"])
    organizational_unit_ids     = optional(list(string))
    account_ids                 = optional(list(string))
    account_filter_type         = optional(string)
    tags                        = optional(map(string), {})
  })
}

variable "name" {
  type = string
}