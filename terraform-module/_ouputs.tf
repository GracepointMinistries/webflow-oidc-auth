output "name" {
  value = var.name
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.api.api_endpoint
}

output "auth_api_route" {
  value = var.auth_api_route
}
