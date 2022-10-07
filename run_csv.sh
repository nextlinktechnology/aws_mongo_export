. ./env.sh
YEAR_MONTH=$1

function write_log {
    date +%F'T'%T' '"${1}"'' >> ${LOG_PATH}
}

# 1. truncate bqload_info
write_log "=== truncate bqload_info ==="
    bq query --use_legacy_sql=false 'CALL `mf-api-dev.aws_billing_data_dev.bqload_info_truncate`();'
write_log "done"
# 2. run aws_usages_monthly
COL="aws_usages_monthly"

write_log "=== ${INSTANCE_TYPE}-${YEAR_MONTH}${COL} ==="
    { mongoexport --config=${RUN_PATH}/conn.yml \
        -d=prd_billing_portal \
        -c=${YEAR_MONTH}${COL} \
        -q='{"fix_line_item_type":{"$ne":"SavingsPlanNegation"}}' \
        --fieldFile=${RUN_PATH}/fields_map/${COL}.txt \
        --noHeaderLine \
        --type=csv \
        -o=${RUN_PATH}/data/${YEAR_MONTH}${COL}.csv; }  2>&1 | tail -n 1 >> ${LOG_PATH}
write_log "== compress to gz file =="
    gzip -kf ${RUN_PATH}/data/${YEAR_MONTH}${COL}.csv
write_log "done"
write_log "== upload to s3 bucket =="
    aws s3 cp --quiet ${RUN_PATH}/data/${YEAR_MONTH}${COL}.csv.gz ${S3_PATH} >> ${LOG_PATH}
write_log "done"
write_log "== add bqload info =="
    bq query --use_legacy_sql=false 'CALL `mf-api-dev.aws_billing_data_dev.bqload_info_add`("'${YEAR_MONTH}${COL}'.csv.gz", "'${YEAR_MONTH}${COL}'");' >> ${LOG_PATH}
write_log "done"
write_log "== create table =="
    bq query --use_legacy_sql=false 'CALL `mf-api-dev.aws_billing_data_dev.create_'${COL}'`("'${YEAR_MONTH}'");' >> ${LOG_PATH}
write_log "done"
# 3. run aws_usages_daily
COL="aws_usages_daily"

write_log "=== ${INSTANCE_TYPE}-${YEAR_MONTH}${COL} ==="
    { mongoexport --config=${RUN_PATH}/conn.yml \
        -d=prd_billing_portal \
        -c=${YEAR_MONTH}${COL} \
        -q='{"fix_line_item_type":{"$ne":"SavingsPlanNegation"}}' \
        --fieldFile=${RUN_PATH}/fields_map/${COL}.txt \
        --noHeaderLine \
        --type=csv \
        -o=${RUN_PATH}/data/${YEAR_MONTH}${COL}.csv; }  2>&1 | tail -n 1 >> ${LOG_PATH}
write_log "== compress to gz file =="
    gzip -kf ${RUN_PATH}/data/${YEAR_MONTH}${COL}.csv
write_log "done"
write_log "== upload to s3 bucket =="
    aws s3 cp --quiet ${RUN_PATH}/data/${YEAR_MONTH}${COL}.csv.gz ${S3_PATH} >> ${LOG_PATH}
write_log "done"
write_log "== add bqload info =="
    bq query --use_legacy_sql=false 'CALL `mf-api-dev.aws_billing_data_dev.bqload_info_add`("'${YEAR_MONTH}${COL}'.csv.gz", "'${YEAR_MONTH}${COL}'");' >> ${LOG_PATH}
write_log "done"
write_log "== create table =="
    bq query --use_legacy_sql=false 'CALL `mf-api-dev.aws_billing_data_dev.create_'${COL}'`("'${YEAR_MONTH}'");' >> ${LOG_PATH}
write_log "done"

# 4. run aws_usages_instance
COL="aws_usages_instance"

write_log "=== ${INSTANCE_TYPE}-${YEAR_MONTH}${COL} ==="
    { mongoexport --config=${RUN_PATH}/conn.yml \
        -d=prd_billing_portal \
        -c=${YEAR_MONTH}${COL} \
        --fieldFile=${RUN_PATH}/fields_map/${COL}.txt \
        --noHeaderLine \
        --type=csv \
        -o=${RUN_PATH}/data/${YEAR_MONTH}${COL}.csv; }  2>&1 | tail -n 1 >> ${LOG_PATH}
write_log "== split files =="
    split -l ${SPLIT_SIZE} --numeric-suffixes ${RUN_PATH}/data/${YEAR_MONTH}${COL}.csv ${RUN_PATH}/data/${YEAR_MONTH}${COL}.p
write_log "done"
write_log "== compress split files to gz files =="
    find ${RUN_PATH}/data/ -name "${YEAR_MONTH}${COL}.p*" | xargs -I arg gzip -kf arg
write_log "done"
write_log "== upload to s3 bucket =="
    find ${RUN_PATH}/data/ -name "${YEAR_MONTH}${COL}.p*.gz" | xargs -I arg aws s3 cp arg ${S3_PATH}
write_log "done"
write_log "== add bqload info =="
    find ${RUN_PATH}/data/ -name "${YEAR_MONTH}${COL}.p*.gz" -printf "%f\n" | xargs -I arg bq query --use_legacy_sql=false 'CALL `mf-api-dev.aws_billing_data_dev.bqload_info_add`("'arg'", "'${YEAR_MONTH}${COL}'");'
write_log "done"
write_log "== create table =="
    bq query --use_legacy_sql=false 'CALL `mf-api-dev.aws_billing_data_dev.create_'${COL}'`("'${YEAR_MONTH}'");' >> ${LOG_PATH}
write_log "done"

# -2. trigger data transfer
write_log "=== trigger data transfer ==="
    gcloud transfer jobs run --no-async ${TRANS_JOBID} >> ${LOG_PATH}
write_log "done"

# -1. stop this instance
write_log "=== trigger lambda self stop ==="
    # aws lambda invoke --function-name mongo_export_ec2_lambda --payload '{"action":"stop_ec2"}' output.txt >> ${LOG_PATH}