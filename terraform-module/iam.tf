data "aws_iam_policy_document" "lambda_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "auth_lambda" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.lambda_execution_role.json

  tags = {
    project = var.project
  }
}

resource "aws_iam_role_policy_attachment" "auth_lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.auth_lambda.name
}
