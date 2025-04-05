/*terraform {
  backend "s3" {
    bucket = "tej-test-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "tej-test-terraform-state-lock"
  }
}*/

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}