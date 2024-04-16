resource "aws_cloudwatch_event_rule" "daily_total_trigger" {
  name                = "daily-trigger"
  description         = "Calculated the daily total every day at 12:00 AM"
  schedule_expression = "cron(0 0 * * ? *)"  # 12:00 AM UTC
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_total_trigger.name
  target_id = "my-lambda-function"
  arn       = aws_lambda_function.daily_total_lambda_function.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.daily_total_lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_total_trigger.arn
}