resource "aws_iam_role" "lambda_role" {
  name = "crud_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
          Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "lambda_execution_policy" {
  name        = "lambda_execution_policy"
  description = "Policy for Lambda function execution"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect   = "Allow",
        Action   = "lambda:InvokeFunction",
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = "textract:*",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_execution_policy_attachment" {
  name       = "lambda_execution_policy_attachment"
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
  roles      = [aws_iam_role.lambda_role.name]
}

resource "aws_iam_policy_attachment" "lambda_dynamodb_policy" {
  name       = "lambda_dynamodb_policy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  roles      = aws_iam_role.lambda_role.*.name
}

resource "aws_iam_role_policy_attachment" "lambda_ses_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}


resource "aws_lambda_function" "lambda_function" {
  function_name = "budgetwise-function"
  description = "Python lambda function to perform CRUD actions on the DynamoDB"
  role = aws_iam_role.lambda_role.arn
  filename = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
  handler = "lambda_function.lambda_handler"
  runtime = "python3.10"
  timeout = 10
}

resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "budgetwise-crud-api"
  description = "REST API to perform CRUD actions using lambda function"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.arn
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

# Lambda permission to invoke Textract
resource "aws_lambda_permission" "textract_permission" {
  statement_id  = "AllowLambdaInvokeTextract"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.arn
  principal     = "textract.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "ses_permission" {
  statement_id  = "AllowLambdaInvokeSES"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.arn
  principal     = "ses.amazonaws.com"
   # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

# creating the api gateway resource
# /expense
resource "aws_api_gateway_resource" "expenses" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "expenses"
}

# creating the api method for a resource
# expense delete
resource "aws_api_gateway_method" "delete_expense" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.expenses.id
  http_method   = "DELETE"
  authorization = "NONE"
}

# creating the api method for a resource
# expense update
resource "aws_api_gateway_method" "patch_expense" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.expenses.id
  http_method   = "PATCH"
  authorization = "NONE"
}

# creating the api method for a resource
# expense create
resource "aws_api_gateway_method" "create_expense" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.expenses.id
  http_method   = "POST"
  authorization = "NONE"
}

# creating the api method for viewing all expenses
resource "aws_api_gateway_method" "view_all_expenses" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.expenses.id
  http_method   = "GET"
  authorization = "NONE"
}

# integrating the lambda function with the api method expense delete
# will be common for all, just change the resource_id and http_method
resource "aws_api_gateway_integration" "lambda_integration_expense_delete" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.expenses.id
  http_method             = aws_api_gateway_method.delete_expense.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# integrating the lambda function with the api method for expense update
# will be common for all, just change the resource_id and http_method
resource "aws_api_gateway_integration" "lambda_integration_expense_update" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.expenses.id
  http_method             = aws_api_gateway_method.patch_expense.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# integrating the lambda function with the api method for expense create
resource "aws_api_gateway_integration" "lambda_integration_expense_create" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.expenses.id
  http_method             = aws_api_gateway_method.create_expense.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# integrating the lambda function with the api method for viewing all expenses
resource "aws_api_gateway_integration" "lambda_integration_view_all_expenses" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.expenses.id
  http_method             = aws_api_gateway_method.view_all_expenses.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# creating the api gateway resource for budgets
# /budgets
resource "aws_api_gateway_resource" "budgets" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "budgets"
}

# creating the api method for a resource to delete a budget
resource "aws_api_gateway_method" "delete_budget" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.budgets.id
  http_method   = "DELETE"
  authorization = "NONE"
}

# creating the api method for a resource to update a budget
resource "aws_api_gateway_method" "patch_budget" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.budgets.id
  http_method   = "PATCH"
  authorization = "NONE"
}

# creating the api method for a resource to create a budget
resource "aws_api_gateway_method" "create_budget" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.budgets.id
  http_method   = "POST"
  authorization = "NONE"
}

# creating the api method for viewing all budgets
resource "aws_api_gateway_method" "view_all_budgets" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.budgets.id
  http_method   = "GET"
  authorization = "NONE"
}

# integrating the lambda function with the api method for deleting a budget
resource "aws_api_gateway_integration" "lambda_integration_budget_delete" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.budgets.id
  http_method             = aws_api_gateway_method.delete_budget.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# integrating the lambda function with the api method for updating a budget
resource "aws_api_gateway_integration" "lambda_integration_budget_update" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.budgets.id
  http_method             = aws_api_gateway_method.patch_budget.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# integrating the lambda function with the api method for creating a budget
resource "aws_api_gateway_integration" "lambda_integration_budget_create" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.budgets.id
  http_method             = aws_api_gateway_method.create_budget.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# integrating the lambda function with the api method for viewing all budgets
resource "aws_api_gateway_integration" "lambda_integration_view_all_budgets" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.budgets.id
  http_method             = aws_api_gateway_method.view_all_budgets.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# creating the api gateway resource for receipts
# /receipts
resource "aws_api_gateway_resource" "receipts" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "receipts"
}

# creating the api method for a resource to analyze a receipt
resource "aws_api_gateway_method" "analyze_receipt" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.receipts.id
  http_method   = "POST"
  authorization = "NONE"
  request_models = {
    "multipart/form-data" = aws_api_gateway_model.multipartFormData.name
  }
}

# integrating the lambda function with the api method for analyzing a receipt
resource "aws_api_gateway_integration" "lambda_integration_analyze_receipt" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.receipts.id
  http_method             = aws_api_gateway_method.analyze_receipt.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# Request model for multipart/form-data
resource "aws_api_gateway_model" "multipartFormData" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  name          = "MultipartFormData"
  content_type  = "multipart/form-data"
  schema        = jsonencode({
    "type": "object",
    "properties": {
      "file": { "type": "string", "format": "binary" }
    }
  })
}

# creating the api gateway resource for reports
# /reports
resource "aws_api_gateway_resource" "reports" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "reports"
}

# creating the api method for a resource to create a report
resource "aws_api_gateway_method" "create_report" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.reports.id
  http_method   = "POST"
  authorization = "NONE"
}

# integrating the lambda function with the api method for deleting a budget
resource "aws_api_gateway_integration" "lambda_integration_report_create" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.reports.id
  http_method             = aws_api_gateway_method.create_report.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# Deploying API Gateway Deployment
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = "dev"
  depends_on = [
    aws_api_gateway_method.delete_expense,
    aws_api_gateway_integration.lambda_integration_expense_delete,
    aws_api_gateway_method.patch_expense,
    aws_api_gateway_integration.lambda_integration_expense_update,
    aws_api_gateway_method.create_expense,
    aws_api_gateway_integration.lambda_integration_expense_create,
    aws_api_gateway_method.view_all_expenses,
    aws_api_gateway_integration.lambda_integration_view_all_expenses,
    aws_api_gateway_method.delete_budget,
    aws_api_gateway_integration.lambda_integration_budget_delete,
    aws_api_gateway_method.patch_budget,
    aws_api_gateway_integration.lambda_integration_budget_update,
    aws_api_gateway_method.create_budget,
    aws_api_gateway_integration.lambda_integration_budget_create,
    aws_api_gateway_method.view_all_budgets,
    aws_api_gateway_integration.lambda_integration_view_all_budgets,
    aws_api_gateway_method.analyze_receipt,
    aws_api_gateway_integration.lambda_integration_analyze_receipt,
    aws_api_gateway_method.create_report,
    aws_api_gateway_integration.lambda_integration_report_create,
    # Add dependencies for other resources as needed
  ]
}