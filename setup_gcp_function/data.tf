# Generate zip of BQ import function
data "archive_file" "storgae_to_bigquery_function" {
  type        = "zip"
  output_path = "/tmp/storgae_to_bigquery_function.zip"
  source {
    content  = file("${var.run_path}/setup_gcp_function/cloud_function/main.py")
    filename = "main.py"
  }
  source {
    content  = file("${var.run_path}/setup_gcp_function/cloud_function/env.py")
    filename = "env.py"
  }
  source {
    content  = file("${var.run_path}/setup_gcp_function/cloud_function/requirements.txt")
    filename = "requirements.txt"
  }
}