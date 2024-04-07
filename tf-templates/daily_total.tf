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
  function_name = "daily-total-function"
  description = "Python lambda function to calculate daily total"
  role = aws_iam_role.lambda_role.arn
  filename = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
  handler = "lambda_function.lambda_handler"
  runtime = "python3.10"
  timeout = 10
}

resource "aws_cloudwatch_event_rule" "daily_total_trigger" {
  name                = "daily-trigger"
  description         = "Calculated the daily total every day at 12:00 AM"
  schedule_expression = "cron(0 0 * * ? *)"  # 12:00 AM UTC
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_total_trigger.name
  target_id = "my-lambda-function"
  arn       = aws_lambda_function.lambda_function.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_total_trigger.arn
}