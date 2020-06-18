variable "prefix" {
  type = string
  default = "rshiny-aws"
}

provider "aws" {
  version = ">= 2.28.1"
  region = var.region
}

# Make sure this matches the name and region you defined in your terraform state
# To get the name look at ../terraform-state/main.tf
//terraform {
//  backend "s3" {
//    bucket = "rshiny-aws-terraform-state"
//    key = "terraform/terraform-dev.tfstate"
//    region = "us-east-1"
//    encrypt = true
//    dynamodb_table = "rshiny-aws-terraform-state-lock"
//  }
//}
