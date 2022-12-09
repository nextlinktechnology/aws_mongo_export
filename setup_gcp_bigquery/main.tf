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

## Stored Procedure: bqload_info_add ##
resource "google_bigquery_routine" "bqload_info_add" {
  dataset_id      = var.dataset_id
  routine_id      = "bqload_info_add"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.bqload_info_add.rendered}"
  arguments {
    name          = "file_name"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" : "STRING" })
  }
  arguments {
    name          = "table_name"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" : "STRING" })
  }
}

## Stored Procedure: bqload_info_truncate ##
resource "google_bigquery_routine" "bqload_info_truncate" {
  dataset_id      = var.dataset_id
  routine_id      = "bqload_info_truncate"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.bqload_info_truncate.rendered}"
}

## Stored Procedure: bqload_info_update ##
resource "google_bigquery_routine" "bqload_info_update" {
  dataset_id      = var.dataset_id
  routine_id      = "bqload_info_update"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.bqload_info_update.rendered}"
  arguments {
    name          = "file_name"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" : "STRING" })
  }
}

## Stored Procedure: create_aws_usages_cfrc_instance ##
resource "google_bigquery_routine" "create_aws_usages_cfrc_instance" {
  dataset_id      = var.dataset_id
  routine_id      = "create_aws_usages_cfrc_instance"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.create_aws_usages_cfrc_instance.rendered}"
  arguments {
    name          = "prefix"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" : "STRING" })
  }
}

## Stored Procedure: create_aws_usages_cr_instance ##
resource "google_bigquery_routine" "create_aws_usages_cr_instance" {
  dataset_id      = var.dataset_id
  routine_id      = "create_aws_usages_cr_instance"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.create_aws_usages_cr_instance.rendered}"
  arguments {
    name          = "prefix"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" : "STRING" })
  }
}

## Stored Procedure: create_aws_usages_daily ##
resource "google_bigquery_routine" "create_aws_usages_daily" {
  dataset_id      = var.dataset_id
  routine_id      = "create_aws_usages_daily"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.create_aws_usages_daily.rendered}"
  arguments {
    name          = "prefix"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" : "STRING" })
  }
}

## Stored Procedure: create_aws_usages_instance ##
resource "google_bigquery_routine" "create_aws_usages_instance" {
  dataset_id      = var.dataset_id
  routine_id      = "create_aws_usages_instance"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.create_aws_usages_instance.rendered}"
  arguments {
    name          = "prefix"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" : "STRING" })
  }
}

## Stored Procedure: create_aws_usages_monthly ##
resource "google_bigquery_routine" "create_aws_usages_monthly" {
  dataset_id      = var.dataset_id
  routine_id      = "create_aws_usages_monthly"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.create_aws_usages_monthly.rendered}"
  arguments {
    name          = "prefix"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" : "STRING" })
  }
}

## Stored Procedure: create_aws_usages_ri_fee ##
resource "google_bigquery_routine" "create_aws_usages_ri_fee" {
  dataset_id      = var.dataset_id
  routine_id      = "create_aws_usages_ri_fee"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.create_aws_usages_ri_fee.rendered}"
}

## Stored Procedure: create_aws_usages_ri_instance ##
resource "google_bigquery_routine" "create_aws_usages_ri_instance" {
  dataset_id      = var.dataset_id
  routine_id      = "create_aws_usages_ri_instance"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.create_aws_usages_ri_instance.rendered}"
  arguments {
    name          = "prefix"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" : "STRING" })
  }
}

## Stored Procedure: create_aws_usages_s3_instance ##
resource "google_bigquery_routine" "create_aws_usages_s3_instance" {
  dataset_id      = var.dataset_id
  routine_id      = "create_aws_usages_s3_instance"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.create_aws_usages_s3_instance.rendered}"
  arguments {
    name          = "prefix"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" : "STRING" })
  }
}

## Stored Procedure: create_aws_usages_sp_fee ##
resource "google_bigquery_routine" "create_aws_usages_sp_fee" {
  dataset_id      = var.dataset_id
  routine_id      = "create_aws_usages_sp_fee"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.create_aws_usages_sp_fee.rendered}"
}

## Stored Procedure: create_aws_usages_sp_instance ##
resource "google_bigquery_routine" "create_aws_usages_sp_instance" {
  dataset_id      = var.dataset_id
  routine_id      = "create_aws_usages_sp_instance"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.create_aws_usages_sp_instance.rendered}"
  arguments {
    name          = "prefix"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" : "STRING" })
  }
}

## Stored Procedure: create_resource_tags ##
resource "google_bigquery_routine" "create_resource_tags" {
  dataset_id      = var.dataset_id
  routine_id      = "create_resource_tags"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.create_resource_tags.rendered}"
  arguments {
    name          = "prefix"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" : "STRING" })
  }
}

## Stored Procedure: replace_tables ##
resource "google_bigquery_routine" "replace_tables" {
  dataset_id      = var.dataset_id
  routine_id      = "replace_tables"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.replace_tables.rendered}"
}