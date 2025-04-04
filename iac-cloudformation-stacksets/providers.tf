provider "aws" {
  region = "us-east-1"
  default_tags { tags = merge(var.default_tags, { region = "us-east-1" }) }
}