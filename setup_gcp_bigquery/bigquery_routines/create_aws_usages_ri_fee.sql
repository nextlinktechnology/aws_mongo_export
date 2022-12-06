-- CREATE OR REPLACE PROCEDURE `${project_id}.${dataset_id}.create_aws_usages_ri_fee`()
BEGIN

-- create _temp suffix table
EXECUTE IMMEDIATE
format("""
  CREATE OR REPLACE TABLE `${project_id}.${dataset_id}.aws_usages_ri_fee_temp`
  (
    fix_line_item_type STRING,
    fix_usage_date DATE,
    lineItem_LineItemType STRING,
    lineItem_UnblendedCost BIGNUMERIC,
    lineItem_UsageAccountId STRING,
    lineItem_UsageEndDate STRING,
    lineItem_UsageStartDate STRING,
    lineItem_UsageType STRING,
    reservation_EndTime STRING,
    reservation_StartTime STRING,
    reservation_SubscriptionId STRING
  )
  CLUSTER BY
    lineItem_UsageAccountId;
""");

-- create main table
EXECUTE IMMEDIATE
format("""
  CREATE TABLE IF NOT EXISTS `${project_id}.${dataset_id}.aws_usages_ri_fee`
  (
    fix_line_item_type STRING,
    fix_usage_date DATE,
    lineItem_LineItemType STRING,
    lineItem_UnblendedCost BIGNUMERIC,
    lineItem_UsageAccountId STRING,
    lineItem_UsageEndDate STRING,
    lineItem_UsageStartDate STRING,
    lineItem_UsageType STRING,
    reservation_EndTime STRING,
    reservation_StartTime STRING,
    reservation_SubscriptionId STRING
  )
  CLUSTER BY
    lineItem_UsageAccountId;
""");

END;