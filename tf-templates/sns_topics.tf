locals {
  phone_numbers = ["+15854062509"]
}

resource "aws_sns_topic" "alert" {
  name = "sms-alert-topic"
}

resource "aws_sns_topic_subscription" "topic_sms_subscription" {
  count     = length(local.phone_numbers)
  topic_arn = aws_sns_topic.alert.arn
  protocol  = "sms"
  endpoint  = local.phone_numbers[count.index]
}