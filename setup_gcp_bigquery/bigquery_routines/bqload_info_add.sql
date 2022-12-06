-- CREATE OR REPLACE PROCEDURE `${project_id}.${dataset_id}.bqload_info_add`(file_name STRING, table_name STRING)
BEGIN

CREATE TABLE IF NOT EXISTS `${project_id}.${dataset_id}.bqload_info`(
  file_name STRING,
  table_name STRING,
  created_at DATETIME,
  updated_at DATETIME,
  status STRING
);

EXECUTE IMMEDIATE
format("""
  INSERT INTO `${project_id}.${dataset_id}.bqload_info` (
    file_name,
    table_name,
    created_at,
    status
  ) VALUES (
    "%s",
    "%s",
    current_datetime(),
    "init"
  );
""", file_name, table_name);

END;