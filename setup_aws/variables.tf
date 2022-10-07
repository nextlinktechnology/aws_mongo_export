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