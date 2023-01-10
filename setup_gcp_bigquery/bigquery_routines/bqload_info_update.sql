BEGIN
-- CREATE OR REPLACE PROCEDURE `${project_id}.${dataset_id}.bqload_info_update`(file_name STRING)

CREATE TABLE IF NOT EXISTS `${project_id}.${dataset_id}.bqload_info`(
  file_name STRING,
  table_name STRING,
  created_at DATETIME,
  updated_at DATETIME,
  status STRING
);

EXECUTE IMMEDIATE
format("""
  UPDATE `${project_id}.${dataset_id}.bqload_info`
  SET
    status = "done",
    updated_at = current_datetime()
  WHERE
    file_name = "%s";
""", file_name);

END;