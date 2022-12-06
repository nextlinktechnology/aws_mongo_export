-- CREATE OR REPLACE PROCEDURE `${project_id}.${dataset_id}.create_aws_usages_instance`(prefix STRING)
BEGIN

-- create _temp suffix table
EXECUTE IMMEDIATE
format("""
  CREATE OR REPLACE TABLE `${project_id}.${dataset_id}.%saws_usages_instance_temp`
  (
    bill_InvoiceId STRING,
    bill_PayerAccountId STRING,
    fix_adjustment STRING,
    fix_line_item_description STRING,
    fix_line_item_type STRING,
    fix_month STRING,
    fix_un_blended_rate BIGNUMERIC,
    fix_un_blended_cost BIGNUMERIC,
    fix_usage_amount BIGNUMERIC,
    fix_usage_date DATE,
    identity_LineItemId STRING,
    lineItem_AvailabilityZone STRING,
    lineItem_BlendedRate BIGNUMERIC,
    lineItem_BlendedCost BIGNUMERIC,
    lineItem_Operation STRING,
    lineItem_ResourceId STRING,
    lineItem_UnblendedRate BIGNUMERIC,
    lineItem_UnblendedCost BIGNUMERIC,
    lineItem_UsageAccountId STRING,
    lineItem_UsageEndDate STRING,
    lineItem_UsageStartDate STRING,
    lineItem_UsageType STRING,
    pricing_RateId STRING,
    product_ProductName STRING,
    reservation_EndTime STRING,
    reservation_StartTime STRING,
    reservation_EffectiveCost BIGNUMERIC,
    reservation_ReservationARN STRING,
    reservation_SubscriptionId STRING,
    reservation_NormalizedUnitsPerReservation BIGNUMERIC,
    reservation_TotalReservedUnits BIGNUMERIC,
    savingsPlan_EndTime STRING,
    savingsPlan_OfferingType STRING,
    savingsPlan_PaymentOption STRING,
    savingsPlan_PurchaseTerm STRING,
    savingsPlan_Region STRING,
    savingsPlan_SavingsPlanARN STRING,
    savingsPlan_SavingsPlanEffectiveCost BIGNUMERIC,
    savingsPlan_SavingsPlanRate BIGNUMERIC,
    savingsPlan_StartTime STRING,
    savingsPlan_TotalCommitmentToDate BIGNUMERIC,
    savingsPlan_UsedCommitment BIGNUMERIC,
    concat_resourceTags_user STRING,
    concat_resourceTags_aws STRING
  )
  PARTITION BY
    fix_usage_date
  CLUSTER BY
    lineItem_UsageAccountId;
""", prefix);

-- create main table
EXECUTE IMMEDIATE
format("""
  CREATE TABLE IF NOT EXISTS `${project_id}.${dataset_id}.%saws_usages_instance`
  (
    bill_InvoiceId STRING,
    bill_PayerAccountId STRING,
    fix_adjustment STRING,
    fix_line_item_description STRING,
    fix_line_item_type STRING,
    fix_month STRING,
    fix_un_blended_rate BIGNUMERIC,
    fix_un_blended_cost BIGNUMERIC,
    fix_usage_amount BIGNUMERIC,
    fix_usage_date DATE,
    identity_LineItemId STRING,
    lineItem_AvailabilityZone STRING,
    lineItem_BlendedRate BIGNUMERIC,
    lineItem_BlendedCost BIGNUMERIC,
    lineItem_Operation STRING,
    lineItem_ResourceId STRING,
    lineItem_UnblendedRate BIGNUMERIC,
    lineItem_UnblendedCost BIGNUMERIC,
    lineItem_UsageAccountId STRING,
    lineItem_UsageEndDate STRING,
    lineItem_UsageStartDate STRING,
    lineItem_UsageType STRING,
    pricing_RateId STRING,
    product_ProductName STRING,
    reservation_EndTime STRING,
    reservation_StartTime STRING,
    reservation_EffectiveCost BIGNUMERIC,
    reservation_ReservationARN STRING,
    reservation_SubscriptionId STRING,
    reservation_NormalizedUnitsPerReservation BIGNUMERIC,
    reservation_TotalReservedUnits BIGNUMERIC,
    savingsPlan_EndTime STRING,
    savingsPlan_OfferingType STRING,
    savingsPlan_PaymentOption STRING,
    savingsPlan_PurchaseTerm STRING,
    savingsPlan_Region STRING,
    savingsPlan_SavingsPlanARN STRING,
    savingsPlan_SavingsPlanEffectiveCost BIGNUMERIC,
    savingsPlan_SavingsPlanRate BIGNUMERIC,
    savingsPlan_StartTime STRING,
    savingsPlan_TotalCommitmentToDate BIGNUMERIC,
    savingsPlan_UsedCommitment BIGNUMERIC,
    concat_resourceTags_user STRING,
    concat_resourceTags_aws STRING
  )
  PARTITION BY
    fix_usage_date
  CLUSTER BY
    lineItem_UsageAccountId;
""", prefix);

END;