output "api_gateway_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}

output "instance_public_ip" {
  value = aws_instance.budgetwise_instance.public_ip
}

output "sns_topic_arn" {
  value = aws_sns_topic.alert.arn
}

output "cognito_config" {
  value = {
    aws_project_region                   = "us-east-1"
    aws_user_pools_id                    = aws_cognito_user_pool.main.id
    aws_user_pools_web_client_id         = aws_cognito_user_pool_client.client.id
    aws_cognito_username_attributes      = ["EMAIL"]
    aws_cognito_signup_attributes        = ["EMAIL", "NAME", "PHONE_NUMBER"]
    aws_cognito_mfa_configuration        = "OFF"
    aws_cognito_mfa_types                = ["SMS"]
    aws_cognito_password_protection_settings = {
      passwordPolicyMinLength           = 8
      passwordPolicyCharacters          = []
    }
    aws_cognito_verification_mechanisms = ["EMAIL"]
  }
  description = "Configuration for the AWS Cognito resources"
}
