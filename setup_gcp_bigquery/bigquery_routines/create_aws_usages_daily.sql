BEGIN
-- CREATE OR REPLACE PROCEDURE `${project_id}.${dataset_id}.create_aws_usages_daily`(prefix STRING)

-- create _temp suffix table
EXECUTE IMMEDIATE
format("""
  CREATE OR REPLACE TABLE `${project_id}.${dataset_id}.%saws_usages_daily_temp`
  (
    _id STRING,
    bill_PayerAccountId STRING,
    fix_cfrc_type STRING,
    fix_line_item_description STRING,
    fix_line_item_type STRING,
    fix_un_blended_cost BIGNUMERIC,
    fix_usage_date DATE,
    lineItem_AvailabilityZone STRING,
    lineItem_UsageAccountId STRING,
    lineItem_UsageAmount BIGNUMERIC,
    lineItem_UsageType STRING,
    product_instanceType STRING,
    product_ProductName STRING,
    product_region STRING,
    reservation_SubscriptionId STRING,
    savingsPlan_SavingsPlanARN STRING,
    resource_tags STRING
  )
  PARTITION BY
    fix_usage_date
  CLUSTER BY
    lineItem_UsageAccountId;
""", prefix);

-- create main table
EXECUTE IMMEDIATE
format("""
  CREATE TABLE IF NOT EXISTS `${project_id}.${dataset_id}.%saws_usages_daily`
  (
    _id STRING,
    bill_PayerAccountId STRING,
    fix_cfrc_type STRING,
    fix_line_item_description STRING,
    fix_line_item_type STRING,
    fix_un_blended_cost BIGNUMERIC,
    fix_usage_date DATE,
    lineItem_AvailabilityZone STRING,
    lineItem_UsageAccountId STRING,
    lineItem_UsageAmount BIGNUMERIC,
    lineItem_UsageType STRING,
    product_instanceType STRING,
    product_ProductName STRING,
    product_region STRING,
    reservation_SubscriptionId STRING,
    savingsPlan_SavingsPlanARN STRING,
    resource_tags STRING
  )
  PARTITION BY
    fix_usage_date
  CLUSTER BY
    lineItem_UsageAccountId;
""", prefix);

END;