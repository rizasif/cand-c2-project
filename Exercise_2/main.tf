provider "aws" {
  access_key = ""
  secret_key = ""
  region = "us-east-1"
}

variable "function_name" {
  default = "lambda_handler"
}

variable "handler" {
  default = "lambda.lambda_handler"
}

variable "runtime" {
  default = "python3.6"
}

resource "aws_lambda_function" "lambda_function" {
  role             = "${aws_iam_role.lambda_exec_role.arn}"
  handler          = "${var.handler}"
  runtime          = "${var.runtime}"
  filename         = "lambda.zip"
  function_name    = "${var.function_name}"
  source_code_hash = "${filebase64("lambda.zip")}"
}

resource "aws_iam_role" "lambda_exec_role" {
  name        = "lambda_exec"
  path        = "/"
  description = "Allows Lambda Function to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "${var.function_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "${aws_iam_role.lambda_exec_role.arn}"
}

resource "aws_lambda_function" "lambda" {
  function_name = "${var.function_name}"

  filename         = "lambda.zip"
  source_code_hash = "${filebase64("lambda.zip")}"

  role    = "${aws_iam_role.lambda_exec_role.arn}"
  handler = "${var.handler}"
  runtime = "python3.6"

  environment {
    variables = {
      greeting = "Terve"
    }
  }
}