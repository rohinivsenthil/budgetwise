output "api_gateway_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}

output "instance_public_ip" {
  value = aws_instance.budgetwise_instance.public_ip
}

output "sns_topic_arn" {
  value = aws_sns_topic.alert.arn
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.main.id
}

output "cognito_user_pool_client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "cognito_identity_pool_id" {
  value = aws_cognito_identity_pool.main_identity_pool.id
}

output "cognito_identity_pool_arn" {
  value = aws_cognito_identity_pool.main_identity_pool.arn
}
