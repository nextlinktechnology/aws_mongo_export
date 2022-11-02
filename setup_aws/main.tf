terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.31.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "ap-northeast-1"
}

## AWS Lambda Function - mongo_export_lambda
resource "aws_lambda_function" "mongo_export_lambda" {
  function_name = var.mongo_export_lambda_function_name

  filename = data.archive_file.mongo_export_lambda.output_path

  # "lambda_function" is the filename within the zip file (lambda_function.py)
  # and "lambda_handler" is the name of the method where the lambda starts
  handler = "lambda_function.lambda_handler"

  runtime = "python3.9"
  timeout = "100"

  role = aws_iam_role.mongo_export_lambda_role.arn
  vpc_config {
    # vpc_id = "vpc-a77257c0"
    subnet_ids         = [var.lambda_subnet_id]
    security_group_ids = [var.lambda_security_group_id]
  }
}

resource "aws_iam_role" "mongo_export_lambda_role" {
  name = var.mongo_export_lambda_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# IAM policy that allows the mongo_export_lambda_role to get required permissions
resource "aws_iam_policy" "mongo_export_lambda_policy" {
  name        = var.mongo_export_lambda_policy_name
  description = "IAM policy for Lambda function to mongo_export"

  path   = "/"
  policy = data.aws_iam_policy_document.mongo_export_lambda.json
}

# Attach policy to IAM role
resource "aws_iam_policy_attachment" "mongo_export_lambda_attach" {
  name       = var.mongo_export_lambda_attach_name
  roles      = ["${aws_iam_role.mongo_export_lambda_role.name}"]
  policy_arn = aws_iam_policy.mongo_export_lambda_policy.arn
}

## AWS Lambda Function - mongo_export_ec2_lambda
resource "aws_lambda_function" "mongo_export_ec2_lambda" {
  function_name = var.mongo_export_ec2_lambda_function_name

  filename = data.archive_file.mongo_export_ec2_lambda.output_path

  # "lambda_function" is the filename within the zip file (lambda_function.py)
  # and "lambda_handler" is the name of the method where the lambda starts
  handler = "lambda_function.lambda_handler"

  runtime = "python3.9"
  timeout = "100"

  role = aws_iam_role.mongo_export_ec2_lambda_role.arn
}

resource "aws_iam_role" "mongo_export_ec2_lambda_role" {
  name = var.mongo_export_ec2_lambda_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# IAM policy that allows the mongo_export_ec2_lambda_role to get required permissions
resource "aws_iam_policy" "mongo_export_ec2_lambda_policy" {
  name        = var.mongo_export_ec2_lambda_policy_name
  description = "IAM policy for Lambda function to mongo_export_ec2"

  path   = "/"
  policy = data.aws_iam_policy_document.mongo_export_ec2_lambda.json
}

# Attach policy to IAM role
resource "aws_iam_policy_attachment" "mongo_export_ec2_lambda_attach" {
  name       = var.mongo_export_ec2_lambda_attach_name
  roles      = ["${aws_iam_role.mongo_export_ec2_lambda_role.name}"]
  policy_arn = aws_iam_policy.mongo_export_ec2_lambda_policy.arn
}