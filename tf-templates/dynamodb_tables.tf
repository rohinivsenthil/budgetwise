resource "aws_dynamodb_table" "users" {
  name           = "users"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  attribute {
    name = "password"
    type = "S"
  }

  attribute {
    name = "phone"
    type = "N"
  }

  global_secondary_index {
    name               = "email-index"
    hash_key           = "email"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "name-index"
    hash_key           = "name"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "phone-index"
    hash_key           = "phone"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "password-index"
    hash_key           = "password"
    projection_type    = "ALL"
  }
}

resource "aws_dynamodb_table" "expenses" {
  name           = "expenses"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "expense_id"

  attribute {
    name = "expense_id"
    type = "S"
  }

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }

  attribute {
    name = "category"
    type = "S"
  }

  attribute {
    name = "amount"
    type = "N"
  }

  attribute {
    name = "date"
    type = "S"
  }

  global_secondary_index {
    name               = "user_id-index"
    hash_key           = "user_id"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "name-index"
    hash_key           = "name"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "category-index"
    hash_key           = "category"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "amount-index"
    hash_key           = "amount"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "date-index"
    hash_key           = "date"
    projection_type    = "ALL"
  }
}

resource "aws_dynamodb_table" "budgets" {
  name           = "budgets"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "budget_id"

  attribute {
    name = "budget_id"
    type = "S"
  }

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "amount"
    type = "N"
  }

  attribute {
    name = "categories"
    type = "S"
  }

  global_secondary_index {
    name               = "user_id-index"
    hash_key           = "user_id"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "amount-index"
    hash_key           = "amount"
    projection_type    = "ALL"
  }

    global_secondary_index {
    name               = "categories-index"
    hash_key           = "categories"
    projection_type    = "ALL"
  }
}
