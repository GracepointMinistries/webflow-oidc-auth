resource "aws_lambda_function" "webflow_auth" {
  function_name    = var.name
  handler          = "src/index.handler"
  role             = aws_iam_role.auth_lambda.arn
  runtime          = "nodejs12.x"
  filename         = var.filename
  source_code_hash = filebase64sha256(var.filename)

  environment {
    variables = {
      OIDC_HD                    = var.oidc_hosted_domain
      WEBFLOW_SITE_AUTH_ENDPOINT = "https://${var.webflow_site_domain}/.wf_auth"
      WEBFLOW_SITE_PASSWORD      = var.webflow_site_password
    }
  }

  tags = {
    project = var.project
  }
}
