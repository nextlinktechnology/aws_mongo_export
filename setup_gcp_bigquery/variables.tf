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