BEGIN
-- CREATE OR REPLACE PROCEDURE `${project_id}.${dataset_id}.create_resource_tags`(prefix STRING)

-- create _temp suffix table
EXECUTE IMMEDIATE
format("""
  CREATE OR REPLACE TABLE `${project_id}.${dataset_id}.%sresource_tags_temp`
  (
    _id STRING,
    payer_account_id STRING,
    usage_account_id STRING,
    resource_tag STRING,
    tag_key STRING,
    tag_value STRING
  )
  CLUSTER BY
    usage_account_id;
""", prefix);

-- create main table
EXECUTE IMMEDIATE
format("""
  CREATE TABLE IF NOT EXISTS `${project_id}.${dataset_id}.%sresource_tags`
  (
    _id STRING,
    payer_account_id STRING,
    usage_account_id STRING,
    resource_tag STRING,
    tag_key STRING,
    tag_value STRING
  )
  CLUSTER BY
    usage_account_id;
""", prefix);

END;