
# Generate zip of mongo_export_lambda
data "archive_file" "mongo_export_lambda" {
  type        = "zip"
  output_path = "/tmp/mongo_export_lambda.zip"
  source {
    content  = file("/home/ubuntu/aws_mongo_export/current/mongo_export_lambda/lambda_function.py")
    filename = "lambda_function.py"
  }
  source {
    content  = file("/home/ubuntu/aws_mongo_export/current/mongo_export_lambda/env.py")
    filename = "env.py"
  }
}

# Generate zip of mongo_export_ec2_lambda
data "archive_file" "mongo_export_ec2_lambda" {
  type        = "zip"
  output_path = "/tmp/mongo_export_ec2_lambda.zip"
  source {
    content  = file("/home/ubuntu/aws_mongo_export/current/mongo_export_ec2_lambda/lambda_function.py")
    filename = "lambda_function.py"
  }
  source {
    content  = file("/home/ubuntu/aws_mongo_export/current/mongo_export_ec2_lambda/env.py")
    filename = "env.py"
  }
}

# mongo_export_lambda iam setting
data "aws_iam_policy_document" "mongo_export_lambda" {
  statement {
    sid = "1"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeNetworkInterfaces"
    ]

    resources = [
      "*",
    ]
  }
}

# mongo_export_ec2_lambda iam setting
data "aws_iam_policy_document" "mongo_export_ec2_lambda" {
  statement {
    sid = "1"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ec2:Start*",
      "ec2:Stop*"
    ]

    resources = [
      "*",
    ]
  }
}