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

resource "aws_iam_policy_attachment" "lambda_execution_policy" {
  name       = "lambda_execution_policy"
  policy_arn = "arn:aws:iam::aws:policy/servicerole/AWSLambdaBasicExecutionRole"
  roles      = aws_iam_role.lambda_role.name
}

resource "aws_iam_policy_attachment" "lambda_dynamodb_policy" {
  name       = "lambda_dynamodb_policy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  roles      = aws_iam_role.lambda_role.name
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "forecast-function"
  description = "Python lambda function to return forecast values"
  role = aws_iam_role.lambda_role.arn
  filename = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
  handler = "lambda_function.lambda_handler"
  runtime = "python3.10"
  timeout = 10
}

resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "budgetwise-forecast-api"
  description = "REST API to return forecast values using lambda function"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# creating the api gateway resource
# /forecast
resource "aws_api_gateway_resource" "forecast" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "forecast"
}

# creating the api method for a resource
# get forecast
resource "aws_api_gateway_method" "get_forecast" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.forecast.id
  http_method   = "GET"
  authorization = "NONE"
}

# integrating the lambda function with the api method expense delete
# will be common for all, just change the resource_id and http_method
resource "aws_api_gateway_integration" "lambda_integration_expense_delete" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.forecast.id
  http_method             = aws_api_gateway_method.get_forecast.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}