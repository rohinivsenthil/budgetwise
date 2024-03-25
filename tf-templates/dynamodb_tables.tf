# initial base structure

terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-2"
}

# user table
# add expenses_table and budget with user entry
resource "aws_dynamodb_table" "user-table" {
  name           = "Users"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }
}

# category table
# add description with category entry
resource "aws_dynamodb_table" "category-table" {
  name           = "Categories"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "category_id"
  range_key      = "name"

  attribute {
    name = "category_id"
    type = "N"
  }

  attribute {
    name = "name"
    type = "S"
  }
}