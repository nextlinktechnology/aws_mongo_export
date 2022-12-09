## Stored Procedure: bqload_info_add ##
data "template_file" "bqload_info_add" {
  template = "${file("${var.run_path}/setup_gcp_bigquery/bigquery_routines/bqload_info_add.sql")}"
  vars = {
    project_id = var.project_id
    dataset_id = var.dataset_id
  }
}

## Stored Procedure: bqload_info_update ##
data "template_file" "bqload_info_update" {
  template = "${file("${var.run_path}/setup_gcp_bigquery/bigquery_routines/bqload_info_update.sql")}"
  vars = {
    project_id = var.project_id
    dataset_id = var.dataset_id
  }
}

## Stored Procedure: bqload_info_truncate ##
data "template_file" "bqload_info_truncate" {
  template = "${file("${var.run_path}/setup_gcp_bigquery/bigquery_routines/bqload_info_truncate.sql")}"
  vars = {
    project_id = var.project_id
    dataset_id = var.dataset_id
  }
}

## Stored Procedure: create_aws_usages_cfrc_instance ##
data "template_file" "create_aws_usages_cfrc_instance" {
  template = "${file("${var.run_path}/setup_gcp_bigquery/bigquery_routines/create_aws_usages_cfrc_instance.sql")}"
  vars = {
    project_id = var.project_id
    dataset_id = var.dataset_id
  }
}

## Stored Procedure: create_aws_usages_cr_instance ##
data "template_file" "create_aws_usages_cr_instance" {
  template = "${file("${var.run_path}/setup_gcp_bigquery/bigquery_routines/create_aws_usages_cr_instance.sql")}"
  vars = {
    project_id = var.project_id
    dataset_id = var.dataset_id
  }
}

## Stored Procedure: create_aws_usages_daily ##
data "template_file" "create_aws_usages_daily" {
  template = "${file("${var.run_path}/setup_gcp_bigquery/bigquery_routines/create_aws_usages_daily.sql")}"
  vars = {
    project_id = var.project_id
    dataset_id = var.dataset_id
  }
}

## Stored Procedure: create_aws_usages_instance ##
data "template_file" "create_aws_usages_instance" {
  template = "${file("${var.run_path}/setup_gcp_bigquery/bigquery_routines/create_aws_usages_instance.sql")}"
  vars = {
    project_id = var.project_id
    dataset_id = var.dataset_id
  }
}

## Stored Procedure: create_aws_usages_monthly ##
data "template_file" "create_aws_usages_monthly" {
  template = "${file("${var.run_path}/setup_gcp_bigquery/bigquery_routines/create_aws_usages_monthly.sql")}"
  vars = {
    project_id = var.project_id
    dataset_id = var.dataset_id
  }
}

## Stored Procedure: create_aws_usages_ri_fee ##
data "template_file" "create_aws_usages_ri_fee" {
  template = "${file("${var.run_path}/setup_gcp_bigquery/bigquery_routines/create_aws_usages_ri_fee.sql")}"
  vars = {
    project_id = var.project_id
    dataset_id = var.dataset_id
  }
}

## Stored Procedure: create_aws_usages_ri_instance ##
data "template_file" "create_aws_usages_ri_instance" {
  template = "${file("${var.run_path}/setup_gcp_bigquery/bigquery_routines/create_aws_usages_ri_instance.sql")}"
  vars = {
    project_id = var.project_id
    dataset_id = var.dataset_id
  }
}

## Stored Procedure: create_aws_usages_s3_instance ##
data "template_file" "create_aws_usages_s3_instance" {
  template = "${file("${var.run_path}/setup_gcp_bigquery/bigquery_routines/create_aws_usages_s3_instance.sql")}"
  vars = {
    project_id = var.project_id
    dataset_id = var.dataset_id
  }
}

## Stored Procedure: create_aws_usages_sp_fee ##
data "template_file" "create_aws_usages_sp_fee" {
  template = "${file("${var.run_path}/setup_gcp_bigquery/bigquery_routines/create_aws_usages_sp_fee.sql")}"
  vars = {
    project_id = var.project_id
    dataset_id = var.dataset_id
  }
}

## Stored Procedure: create_aws_usages_sp_instance ##
data "template_file" "create_aws_usages_sp_instance" {
  template = "${file("${var.run_path}/setup_gcp_bigquery/bigquery_routines/create_aws_usages_sp_instance.sql")}"
  vars = {
    project_id = var.project_id
    dataset_id = var.dataset_id
  }
}

## Stored Procedure: create_resource_tags ##
data "template_file" "create_resource_tags" {
  template = "${file("${var.run_path}/setup_gcp_bigquery/bigquery_routines/create_resource_tags.sql")}"
  vars = {
    project_id = var.project_id
    dataset_id = var.dataset_id
  }
}

## Stored Procedure: replace_tables ##
data "template_file" "replace_tables" {
  template = "${file("${var.run_path}/setup_gcp_bigquery/bigquery_routines/replace_tables.sql")}"
  vars = {
    project_id = var.project_id
    dataset_id = var.dataset_id
  }
}
