BEGIN
-- CREATE OR REPLACE PROCEDURE `${project_id}.${dataset_id}.create_aws_usages_sp_fee`()

-- create _temp suffix table
EXECUTE IMMEDIATE
format("""
  CREATE OR REPLACE TABLE `${project_id}.${dataset_id}.aws_usages_sp_fee_temp`
  (
    bill_BillType STRING,
    fix_line_item_type STRING,
    fix_usage_date DATE,
    lineItem_LineItemType STRING,
    lineItem_UnblendedCost BIGNUMERIC,
    lineItem_UsageAccountId STRING,
    lineItem_UsageType STRING,
    savingsPlan_EndTime STRING,
    savingsPlan_SavingsPlanARN STRING,
    savingsPlan_StartTime STRING,
  )
  CLUSTER BY
    lineItem_UsageAccountId;
""");

-- create main table
EXECUTE IMMEDIATE
format("""
  CREATE TABLE IF NOT EXISTS `${project_id}.${dataset_id}.aws_usages_sp_fee`
  (
    bill_BillType STRING,
    fix_line_item_type STRING,
    fix_usage_date DATE,
    lineItem_LineItemType STRING,
    lineItem_UnblendedCost BIGNUMERIC,
    lineItem_UsageAccountId STRING,
    lineItem_UsageType STRING,
    savingsPlan_EndTime STRING,
    savingsPlan_SavingsPlanARN STRING,
    savingsPlan_StartTime STRING,
  )
  CLUSTER BY
    lineItem_UsageAccountId;
""");

END;