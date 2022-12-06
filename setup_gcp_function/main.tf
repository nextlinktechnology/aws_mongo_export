terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.34.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "google" {
  credentials = "${var.run_path}/.key/keyfile.json"
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket_object" "archive" {
  name   = "storgae_to_bigquery_function.zip"
  bucket = var.function_bucket
  source = data.archive_file.storgae_to_bigquery_function.output_path
}

resource "google_cloudfunctions_function" "storgae_to_bigquery_function" {
  name        = "storgae_to_bigquery_function"
  description = "storgae_to_bigquery_function"
  runtime     = "python310"

  available_memory_mb   = 256
  service_account_email = "api-server@mf-api-dev.iam.gserviceaccount.com"
  source_archive_bucket = var.function_bucket
  source_archive_object = google_storage_bucket_object.archive.name
  event_trigger {
    event_type = "google.storage.object.finalize"
    resource = var.import_bucket
  }
  entry_point = "load_bigquery"
  timeout = 500
}