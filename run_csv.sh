. ./env.sh
YEAR_MONTH=$1

function write_log {
    date +%F'T'%T' '"${1}"'' >> ${LOG_PATH}
}

function export_year_month_usages {
    COL=$1

    write_log "=== ${INSTANCE_TYPE}-${YEAR_MONTH}${COL} ==="
    { mongoexport --config=${RUN_PATH}/conn.yml \
        -d=prd_billing_portal \
        -c=${YEAR_MONTH}${COL} \
        -q='{"fix_line_item_type":{"$ne":"SavingsPlanNegation"}}' \
        --fieldFile=${RUN_PATH}/fields_map/${COL}.txt \
        --noHeaderLine \
        --type=csv \
        -o=${DATA_PATH}/${YEAR_MONTH}${COL}.csv; }  2>&1 | tail -n 1 >> ${LOG_PATH}
    HEAD_COUNT=$(head ${DATA_PATH}/${YEAR_MONTH}${COL}.csv -n 1 | wc -l)
    if [[ $HEAD_COUNT -gt 0 ]]
    then
    write_log "== split files =="
        split -l ${SPLIT_SIZE} --numeric-suffixes -a 4 ${DATA_PATH}/${YEAR_MONTH}${COL}.csv ${DATA_PATH}/${YEAR_MONTH}${COL}.p
    write_log "done"
    write_log "== compress split files to gz files =="
        find ${DATA_PATH}/ -name "${YEAR_MONTH}${COL}.p*" | xargs -I arg gzip -kf arg
    write_log "done"
    write_log "== upload to s3 bucket =="
        find ${DATA_PATH}/ -name "${YEAR_MONTH}${COL}.p*.gz" | xargs -I arg aws s3 cp arg ${S3_PATH}
    write_log "done"
    write_log "== add bqload info =="
        find ${DATA_PATH}/ -name "${YEAR_MONTH}${COL}.p*.gz" -printf "%f\n" | xargs -I arg bq query --use_legacy_sql=false 'CALL `'${PROJECT_NAME}'.'${DATASET_NAME}'.bqload_info_add`("'arg'", "'${YEAR_MONTH}${COL}'");'
    write_log "done"
    write_log "== create table =="
        bq query --use_legacy_sql=false 'CALL `'${PROJECT_NAME}'.'${DATASET_NAME}'.create_'${COL}'`("'${YEAR_MONTH}'");' >> ${LOG_PATH}
    write_log "done"
    else
    write_log "== since no data, skip bqload =="
    fi
}

function export_year_month_tags {
    COL=$1

    write_log "=== ${INSTANCE_TYPE}-${YEAR_MONTH}${COL} ==="
        { mongoexport --config=${RUN_PATH}/conn.yml \
            -d=prd_billing_portal \
            -c=${YEAR_MONTH}${COL} \
            --fieldFile=${RUN_PATH}/fields_map/${COL}.txt \
            --noHeaderLine \
            --type=csv \
            -o=${DATA_PATH}/${YEAR_MONTH}${COL}.csv; }  2>&1 | tail -n 1 >> ${LOG_PATH}
    HEAD_COUNT=$(head ${DATA_PATH}/${YEAR_MONTH}${COL}.csv -n 1 | wc -l)
    if [[ $HEAD_COUNT -gt 0 ]]
    then
    write_log "== split files =="
        split -l ${SPLIT_SIZE} --numeric-suffixes -a 4 ${DATA_PATH}/${YEAR_MONTH}${COL}.csv ${DATA_PATH}/${YEAR_MONTH}${COL}.p
    write_log "done"
    write_log "== compress split files to gz files =="
        find ${DATA_PATH}/ -name "${YEAR_MONTH}${COL}.p*" | xargs -I arg gzip -kf arg
    write_log "done"
    write_log "== upload to s3 bucket =="
        find ${DATA_PATH}/ -name "${YEAR_MONTH}${COL}.p*.gz" | xargs -I arg aws s3 cp arg ${S3_PATH}
    write_log "done"
    write_log "== add bqload info =="
        find ${DATA_PATH}/ -name "${YEAR_MONTH}${COL}.p*.gz" -printf "%f\n" | xargs -I arg bq query --use_legacy_sql=false 'CALL `'${PROJECT_NAME}'.'${DATASET_NAME}'.bqload_info_add`("'arg'", "'${YEAR_MONTH}${COL}'");'
    write_log "done"
    write_log "== create table =="
        bq query --use_legacy_sql=false 'CALL `'${PROJECT_NAME}'.'${DATASET_NAME}'.create_'${COL}'`("'${YEAR_MONTH}'");' >> ${LOG_PATH}
    write_log "done"
    else
    write_log "== since no data, skip bqload =="
    fi
}

function export_fee {
    COL=$1

    write_log "=== ${INSTANCE_TYPE}-${COL} ==="
        { mongoexport --config=${RUN_PATH}/conn.yml \
            -d=prd_billing_portal \
            -c=${COL} \
            -q='{"fix_line_item_type":{"$ne":"SavingsPlanNegation"}}' \
            --fieldFile=${RUN_PATH}/fields_map/${COL}.txt \
            --noHeaderLine \
            --type=csv \
            -o=${DATA_PATH}/${COL}.csv; }  2>&1 | tail -n 1 >> ${LOG_PATH}
    HEAD_COUNT=$(head ${DATA_PATH}/${COL}.csv -n 1 | wc -l)
    if [[ $HEAD_COUNT -gt 0 ]]
    then
    write_log "== split files =="
        split -l ${SPLIT_SIZE} --numeric-suffixes -a 4 ${DATA_PATH}/${COL}.csv ${DATA_PATH}/${COL}.p
    write_log "done"
    write_log "== compress split files to gz files =="
        find ${DATA_PATH}/ -name "${COL}.p*" | xargs -I arg gzip -kf arg
    write_log "done"
    write_log "== upload to s3 bucket =="
        find ${DATA_PATH}/ -name "${COL}.p*.gz" | xargs -I arg aws s3 cp arg ${S3_PATH}
    write_log "done"
    write_log "== add bqload info =="
        find ${DATA_PATH}/ -name "${COL}.p*.gz" -printf "%f\n" | xargs -I arg bq query --use_legacy_sql=false 'CALL `'${PROJECT_NAME}'.'${DATASET_NAME}'.bqload_info_add`("'arg'", "'${COL}'");'
    write_log "done"
    write_log "== create table =="
        bq query --use_legacy_sql=false 'CALL `'${PROJECT_NAME}'.'${DATASET_NAME}'.create_'${COL}'`();' >> ${LOG_PATH}
    write_log "done"
    else
    write_log "== since no data, skip bqload =="
    fi
}

# 1. truncate bqload_info
write_log "=== truncate bqload_info ==="
    bq query --use_legacy_sql=false 'CALL `'${PROJECT_NAME}'.'${DATASET_NAME}'.bqload_info_truncate`();'
write_log "done"

# 2. run aws_usages_monthly
export_year_month_usages "aws_usages_monthly"

# 3. run aws_usages_daily
export_year_month_usages "aws_usages_daily"

# 4. run resource_tags
export_year_month_tags "resource_tags"

# 5. run aws_usages_cfrc_instance
export_year_month_usages "aws_usages_cfrc_instance"

# 6. run aws_usages_cr_instance
export_year_month_usages "aws_usages_cr_instance"

# 7. run aws_usages_ri_instance
export_year_month_usages "aws_usages_ri_instance"

# 8. run aws_usages_s3_instance
export_year_month_usages "aws_usages_s3_instance"

# 9. run aws_usages_sp_instance
export_year_month_usages "aws_usages_sp_instance"

# 10. run aws_usages_ri_fee
export_fee "aws_usages_ri_fee"

# 11. run aws_usages_sp_fee
export_fee "aws_usages_sp_fee"

# 12. run aws_usages_instance
export_year_month_usages "aws_usages_instance"

# -2. trigger data transfer
write_log "=== trigger data transfer ==="
    gcloud transfer jobs run --no-async ${TRANS_JOBID} >> ${LOG_PATH}
write_log "done"

# -1. stop this instance
write_log "=== trigger self stop ==="
    aws ec2 stop-instances --instance-ids ${INSTANCE_ID}