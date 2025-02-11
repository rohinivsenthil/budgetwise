resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "budgetwise-crud-api"
  description = "REST API to perform CRUD actions using lambda function"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
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

# creating the api method for options
resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.expenses.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.expenses.id
  http_method   = aws_api_gateway_method.options_method.http_method
  status_code   = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.expenses.id
  http_method   = aws_api_gateway_method.options_method.http_method
  type          = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.expenses.id
  http_method   = aws_api_gateway_method.options_method.http_method
  status_code   = aws_api_gateway_method_response.options_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Requested-With'",
    "method.response.header.Access-Control-Allow-Methods" = "'*'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
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

# integrating the lambda function with the api method for creating a report
resource "aws_api_gateway_integration" "lambda_integration_report_create" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.reports.id
  http_method             = aws_api_gateway_method.create_report.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# creating the api gateway resource for alerts
# /alerts
resource "aws_api_gateway_resource" "alerts" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "alerts"
}

# creating the api method for a resource to create an alert
resource "aws_api_gateway_method" "create_alert" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.alerts.id
  http_method   = "POST"
  authorization = "NONE"
}

# integrating the lambda function with the api method for creating an alert
resource "aws_api_gateway_integration" "lambda_integration_alert_create" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.alerts.id
  http_method             = aws_api_gateway_method.create_alert.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

# creating the api gateway resource for forecast
# /forecast
resource "aws_api_gateway_resource" "forecast" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "forecast"
}

# creating the api method for a resource to get forecasted values
resource "aws_api_gateway_method" "get_forecast" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.forecast.id
  http_method             = "GET"
  authorization           = "NONE"
}

# integrating the lambda function with the api method for forecasting
resource "aws_api_gateway_integration" "lambda_integration_forecasting" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.forecast.id
  http_method             = aws_api_gateway_method.get_forecast.http_method
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
    aws_api_gateway_method.create_alert,
    aws_api_gateway_integration.lambda_integration_alert_create,
    aws_api_gateway_method.get_forecast,
    aws_api_gateway_integration.lambda_integration_forecasting,
    aws_api_gateway_method.options_method,
    aws_api_gateway_integration.options_integration,
    aws_api_gateway_method_response.options_200,
    aws_api_gateway_integration_response.options_integration_response,
    # Add dependencies for other resources as needed
  ]
}