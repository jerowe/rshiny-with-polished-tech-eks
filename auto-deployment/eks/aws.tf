variable "prefix" {
  type = string
  default = "rshiny-aws"
}

provider "aws" {
  version = ">= 2.28.1"
  region = var.region
}

# Make sure this matches the name and region you defined in your terraform state
# cd ../terraform-state
# terraform output
# then get the value of terraform-state
terraform {
  backend "s3" {
    # Update this
    bucket = "rshiny-aws-lzesfeew-terraform-state"
    key = "terraform/terraform-dev.tfstate"
    # Use the same region you used in auto-deplment/terraform-state/main.tf
    region = "us-east-1"
    encrypt = true
    # Update this
    dynamodb_table = "rshiny-aws-lzesfeew-terraform-state-lock"
  }
}
