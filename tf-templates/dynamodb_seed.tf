resource "aws_dynamodb_table_item" "user_seed" {
  table_name = aws_dynamodb_table.users.name
  depends_on = [aws_dynamodb_table.users]

  hash_key = "user_id"

  item = jsonencode({
    "user_id"  : {"S": "1"},
    "name"     : {"S": "John Doe"},
    "email"    : {"S": "john@example.com"},
    "password" : {"S": "password123"},
    "phone"    : {"N": "1234567890"}
  })
}

locals {
  expense_data = [
    {
      "expense_id": 1,
      "date": "03/14/2024",
      "name": "Wegmans",
      "category": "Groceries",
      "amount": 25.0
    },
    {
      "expense_id": 2,
      "date": "03/14/2024",
      "name": "RGE",
      "category": "Utilities",
      "amount": 34.0
    },
    {
      "expense_id": 3,
      "date": "03/14/2024",
      "name": "Smashburger",
      "category": "Food",
      "amount": 12.5
    },
    {
      "expense_id": 4,
      "date": "03/14/2024",
      "name": "Chipotle",
      "category": "Food",
      "amount": 11.0
    },
    {
      "expense_id": 5,
      "date": "03/14/2024",
      "name": "Movie",
      "category": "Other",
      "amount": 8.0
    },
    {
      "expense_id": 6,
      "date": "03/14/2024",
      "name": "Walmart",
      "category": "Groceries",
      "amount": 32.0
    }
  ]
}

resource "aws_dynamodb_table_item" "expenses_seed" {
  for_each    = { for idx, expense in local.expense_data : idx => expense }
  table_name  = aws_dynamodb_table.expenses.name
  depends_on  = [aws_dynamodb_table.expenses]

  hash_key    = "expense_id"

  item = jsonencode({
    "expense_id" : {"S": tostring(each.value.expense_id)},
    "user_id"  : {"S": "1"},
    "date"       : {"S": each.value.date},
    "name"       : {"S": each.value.name},
    "category"   : {"S": each.value.category},
    "amount"     : {"N": tostring(each.value.amount)}
  })
}

locals {
  budget_categories = {
    "utilities": 100,
    "groceries": 100,
    "food": 100,
    "other": 200
  }
}

resource "aws_dynamodb_table_item" "budgets_seed" {
  table_name  = aws_dynamodb_table.budgets.name
  depends_on  = [aws_dynamodb_table.budgets]

  hash_key    = "budget_id"

  item = jsonencode({
    "budget_id"  : {"S": "1"},
    "user_id"    : {"S": "1"},
    "amount"     : {"N": "500"},
    "categories" : {"S": jsonencode(local.budget_categories)}
  })
}
