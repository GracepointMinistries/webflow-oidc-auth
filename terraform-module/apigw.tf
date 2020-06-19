resource "aws_apigatewayv2_api" "api" {
  name          = var.name
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = concat(["https://${var.webflow_site_domain}"], var.additional_api_allow_origins)
    allow_methods = [
      "POST",
      "OPTIONS"
    ]
    allow_headers = [
      "*"
    ]
    allow_credentials = true
    expose_headers = [
      "*"
    ]
  }

  tags = {
    project = var.project
  }
}

resource "aws_apigatewayv2_authorizer" "oidc" {
  name            = "${var.name}-oidc"
  api_id          = aws_apigatewayv2_api.api.id
  authorizer_type = "JWT"
  identity_sources = [
    "$request.header.Authorization"
  ]

  jwt_configuration {
    issuer = var.oidc_issuer
    audience = [
      var.oidc_audience
    ]
  }
}

resource "aws_apigatewayv2_integration" "webflow_auth_lambda" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.webflow_auth.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "webflow_auth" {
  api_id             = aws_apigatewayv2_api.api.id
  route_key          = "POST /${var.auth_api_route}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.oidc.id
  target             = "integrations/${aws_apigatewayv2_integration.webflow_auth_lambda.id}"
}

resource "aws_apigatewayv2_stage" "api_default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true

  tags = {
    project = var.project
  }
}

resource "aws_lambda_permission" "auth_lambda_invoke_from_apigw" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.webflow_auth.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*/${var.auth_api_route}"
}
