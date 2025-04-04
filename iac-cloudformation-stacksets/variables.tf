variable "default_tags" {
  type = object({
    jira    =   string
    account_name = string
    account_number = string
    product = string
    environment = string
    domain = string
    deployment = string 
  })
  description = "Tags definition"
}