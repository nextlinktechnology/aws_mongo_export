-- CREATE OR REPLACE PROCEDURE `${project_id}.${dataset_id}.bqload_info_truncate`()
BEGIN

CREATE TABLE IF NOT EXISTS `${project_id}.${dataset_id}.bqload_info_history`(
  file_name STRING,
  table_name STRING,
  created_at DATETIME,
  updated_at DATETIME,
  status STRING,
  truncate_date DATE
);

CREATE TABLE IF NOT EXISTS `${project_id}.${dataset_id}.bqload_info`(
  file_name STRING,
  table_name STRING,
  created_at DATETIME,
  updated_at DATETIME,
  status STRING
);

INSERT INTO `${project_id}.${dataset_id}.bqload_info_history`(
  file_name,
  table_name,
  created_at,
  updated_at,
  status,
  truncate_date
)
SELECT
  file_name,
  table_name,
  created_at,
  updated_at,
  status,
  current_date()
FROM `${project_id}.${dataset_id}.bqload_info`;

TRUNCATE TABLE `${project_id}.${dataset_id}.bqload_info`;

END;