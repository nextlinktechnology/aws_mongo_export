BEGIN
-- CREATE OR REPLACE PROCEDURE `${project_id}.${dataset_id}.replace_tables`()

DECLARE COUNT_ALL, COUNT_DONE INT64 DEFAULT 0;

SET (COUNT_ALL) = (
  SELECT AS STRUCT COUNT(*) FROM `${project_id}.${dataset_id}.bqload_info`
);
SET (COUNT_DONE) = (
  SELECT AS STRUCT COUNT(*) FROM `${project_id}.${dataset_id}.bqload_info` WHERE status = "done"
);

IF COUNT_ALL <> COUNT_DONE OR COUNT_ALL = 0 THEN
  RETURN;
END IF;

FOR record IN (SELECT DISTINCT table_name FROM `${project_id}.${dataset_id}.bqload_info`)
DO
  /* REPLACE _old TABLE */
  EXECUTE IMMEDIATE
  format("""
    DROP TABLE IF EXISTS `${project_id}.${dataset_id}.%s_old`;
  """, record.table_name);

  EXECUTE IMMEDIATE
  format("""
    CREATE TABLE `${project_id}.${dataset_id}.%s_old` COPY `${project_id}.${dataset_id}.%s`;
  """, record.table_name, record.table_name);

  /* REPLACE main TABLE */
  EXECUTE IMMEDIATE
  format("""
    DROP TABLE IF EXISTS `${project_id}.${dataset_id}.%s`;
  """, record.table_name);

  IF record.table_name LIKE "%aws_usages_daily" THEN
    EXECUTE IMMEDIATE
    format("""
      CREATE TABLE `${project_id}.${dataset_id}.%s`
      PARTITION BY
        fix_usage_date
      CLUSTER BY
        lineItem_UsageAccountId
      AS 
      SELECT * EXCEPT(resource_tags), JSON_EXTRACT_STRING_ARRAY(resource_tags, "$") AS resource_tags
      FROM `${project_id}.${dataset_id}.%s_temp`;
    """, record.table_name, record.table_name);
  ELSEIF record.table_name LIKE "%aws_usages_monthly" THEN
    EXECUTE IMMEDIATE
    format("""
      CREATE TABLE `${project_id}.${dataset_id}.%s`
      CLUSTER BY
        lineItem_UsageAccountId
      AS 
      SELECT * EXCEPT(resource_tags), JSON_EXTRACT_STRING_ARRAY(resource_tags, "$") AS resource_tags
      FROM `${project_id}.${dataset_id}.%s_temp`;
    """, record.table_name, record.table_name);
  ELSEIF record.table_name LIKE "%resource_tags" THEN
    EXECUTE IMMEDIATE
    format("""
      CREATE TABLE `${project_id}.${dataset_id}.%s`
      CLUSTER BY
        usage_account_id
      AS 
      SELECT REGEXP_REPLACE(_id ,"ObjectId\\\\(|\\\\)", "") AS _id, * EXCEPT(_id)
      FROM `${project_id}.${dataset_id}.%s_temp`;
    """, record.table_name, record.table_name);
  ELSE
    EXECUTE IMMEDIATE
    format("""
      CREATE TABLE `${project_id}.${dataset_id}.%s` COPY `${project_id}.${dataset_id}.%s_temp`;
    """, record.table_name, record.table_name);
  END IF;

  /* DROP _temp TABLE */
  EXECUTE IMMEDIATE
  format("""
    DROP TABLE IF EXISTS `${project_id}.${dataset_id}.%s_temp`;
  """, record.table_name);
END FOR;

SELECT "Success" AS result;

END;