output "api_gateway_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}

output "instance_public_ip" {
  value = aws_instance.budgetwise_instance.public_ip
}
