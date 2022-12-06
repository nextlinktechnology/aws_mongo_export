## terraform env
variable "run_path" {
  description = "terraform_run_path"
  type        = string
  default     = "/home/ubuntu/aws_mongo_export/current"
}

## GCP Global Config
variable "project_id" {
description = "project_id"
  type        = string
  default     = "mf-api-dev"
}

variable "region" {
description = "region"
  type        = string
  default     = "asia-east1"
}

## GCP BigQuery Config
variable "dataset_id" {
  description = "dataset_id"
  type        = string
  default     = "terraform_test"
}

## GCP Storage Config
variable "function_bucket" {
  description = "function_bucket"
  type        = string
  default     = "function-bucket-mgjb8b"
}

variable "import_bucket" {
  description = "import_bucket"
  type        = string
  default     = "terraform-test-yvhsk4"
}