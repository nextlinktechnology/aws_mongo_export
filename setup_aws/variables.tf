## mongo_export_lambda VPC config
variable "lambda_subnet_id" {
  description = "VPC subnet_id for export mongodb and export instance"
  type        = string
  default     = "subnet-af9dccf4"
}

variable "lambda_security_group_id" {
  description = "VPC security group id for export mongodb and export instance"
  type        = string
  default     = "sg-08060f987f9991752"
}

## mongo_export_lambda name config
variable "mongo_export_lambda_function_name" {
  description = "function name of mongo_export_lambda"
  type        = string
  default     = "mongo_export_lambda_test"
}

variable "mongo_export_lambda_role_name" {
  description = "name of mongo_export_lambda_role"
  type        = string
  default     = "mongo_export_lambda_role_test"
}

variable "mongo_export_lambda_policy_name" {
  description = "name of mongo_export_lambda_policy"
  type        = string
  default     = "mongo_export_lambda_policy_test"
}

variable "mongo_export_lambda_attach_name" {
  description = "name of mongo_export_lambda_attach"
  type        = string
  default     = "mongo_export_lambda_attach_test"
}

## mongo_export_ec2_lambda name config
variable "mongo_export_ec2_lambda_function_name" {
  description = "function name of mongo_export_ec2_lambda"
  type        = string
  default     = "mongo_export_ec2_lambda_test"
}

variable "mongo_export_ec2_lambda_role_name" {
  description = "name of mongo_export_ec2_lambda_role"
  type        = string
  default     = "mongo_export_ec2_lambda_role_test"
}

variable "mongo_export_ec2_lambda_policy_name" {
  description = "name of mongo_export_ec2_lambda_policy"
  type        = string
  default     = "mongo_export_ec2_lambda_policy_test"
}

variable "mongo_export_ec2_lambda_attach_name" {
  description = "name of mongo_export_ec2_lambda_attach"
  type        = string
  default     = "mongo_export_ec2_lambda_attach_test"
}