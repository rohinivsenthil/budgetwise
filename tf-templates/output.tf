output "api_gateway_endpoint" {
  value = aws_api_gateway_rest_api.rest_api.execution_arn
}

output "instance_public_ip" {
  value = aws_instance.budgetwise_instance.public_ip
}
