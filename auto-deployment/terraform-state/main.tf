# project/terraform-state/main.tf
# Change the rshiny to something that makes sense
# And the AWS_REGION to the region you want to deploy in

variable "prefix" {
  type = string
  default = "rshiny-aws"
}

# You can also just grab the current region
//data "aws_region" "current" {}
//region = data.aws_region.current.name

variable "region" {
  default = "us-east-1"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

resource "aws_s3_bucket" "terraform-state" {
  bucket = "${var.prefix}-terraform-state"
  acl = "private"
  region = var.region

  versioning {
    enabled = true
  }

  tags = {
    Name = "rshiny"
  }
}

resource "aws_dynamodb_table" "terraform-state-lock" {
  name = "${var.prefix}-terraform-state-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
