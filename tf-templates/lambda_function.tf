resource "aws_lambda_function" "lambda_function" {
  function_name = "budgetwise-function"
  description = "Python lambda function to perform CRUD actions on the DynamoDB"
  role = aws_iam_role.lambda_role.arn
  filename = "crud_lambda_function.zip"
  source_code_hash = filebase64sha256("crud_lambda_function.zip")
  handler = "crud_lambda_function.lambda_handler"
  runtime = "python3.10"
  timeout = 10
}

resource "aws_lambda_function" "daily_total_lambda_function" {
  function_name = "budgetwise-daily-total-function"
  description = "Python lambda function to calculate daily total"
  role = aws_iam_role.lambda_role.arn
  filename = "daily_total_function.zip"
  source_code_hash = filebase64sha256("daily_total_function.zip")
  handler = "daily_total_function.lambda_handler"
  runtime = "python3.10"
  timeout = 10
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

resource "aws_lambda_permission" "sns_permission" {
  statement_id  = "AllowLambdaInvokeSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.arn
  principal     = "sns.amazonaws.com"

  source_arn    = aws_sns_topic.alert.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.daily_total_lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_total_trigger.arn
}
