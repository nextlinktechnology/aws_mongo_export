import env

def load_bigquery(event, context):
    """Triggered by a change to a Cloud Storage bucket.
    Args:
         event (dict): Event payload.
         context (google.cloud.functions.Context): Metadata for the event.
    """
    from google.cloud import bigquery
    from google.api_core.exceptions import BadRequest
    import re
    import time

    dataset = env.DATASET
    print(f'Incoming data: {event}')

    input_bucket_name = event["bucket"]
    source_file = event["name"]
    uri = f'gs://{input_bucket_name}/{source_file}'

    if source_file.lower().endswith(".csv.gz"):
        table = source_file.replace(".csv.gz", "_temp")

        client = bigquery.Client()
        dataset_ref = client.dataset(dataset)

        job_config = bigquery.LoadJobConfig()
        job_config.schema_update_options = [
            bigquery.SchemaUpdateOption.ALLOW_FIELD_ADDITION
        ]
        job_config.source_format = bigquery.SourceFormat.CSV
        job_config.write_disposition = bigquery.WriteDisposition.WRITE_APPEND
        # job_config.skip_leading_rows = 1

        load_job = client.load_table_from_uri(
            uri,
            dataset_ref.table(table),
            job_config=job_config)

        print('Starting job {}'.format(load_job.job_id))

        load_job.result()
        print('Load job finished.')

        def try_update(count):
            if count >= 10:
                update_info_job = client.query(f'CALL `{dataset}.bqload_info_update`("{source_file}")')
                update_info_job.result()
                print('Update info job finished.')
            else:
                try:
                    update_info_job = client.query(f'CALL `{dataset}.bqload_info_update`("{source_file}")')
                    update_info_job.result()
                    print('Update info job finished.')
                except BadRequest:
                    time.sleep(10)
                    print(f'Exceeded rate limits, tried {count} times')
                    next_count = count + 1
                    return try_update(next_count)

        try_update(1)


        replace_tab_job = client.query(f'CALL `{dataset}.replace_tables`()')
        replace_tab_job.result()
        print('Replace tab job finished.')

    if re.findall("\.p\d\d\d\d\.gz$", source_file.lower()):
        table = re.sub("\.p\d\d\d\d\.gz$", "_temp", source_file.lower())

        client = bigquery.Client()
        dataset_ref = client.dataset(dataset)

        job_config = bigquery.LoadJobConfig()
        job_config.schema_update_options = [
            bigquery.SchemaUpdateOption.ALLOW_FIELD_ADDITION
        ]
        job_config.source_format = bigquery.SourceFormat.CSV
        job_config.write_disposition = bigquery.WriteDisposition.WRITE_APPEND

        load_job = client.load_table_from_uri(
            uri,
            dataset_ref.table(table),
            job_config=job_config)

        print('Starting job {}'.format(load_job.job_id))

        load_job.result()
        print('Load job finished.')

        def try_update(count):
            if count >= 10:
                update_info_job = client.query(f'CALL `{dataset}.bqload_info_update`("{source_file}")')
                update_info_job.result()
                print('Update info job finished.')
            else:
                try:
                    update_info_job = client.query(f'CALL `{dataset}.bqload_info_update`("{source_file}")')
                    update_info_job.result()
                    print('Update info job finished.')
                except BadRequest:
                    time.sleep(10)
                    print(f'Exceeded rate limits, tried {count} times')
                    next_count = count + 1
                    return try_update(next_count)

        try_update(1)

        # update_info_job = client.query(f'CALL `{dataset}.bqload_info_update`("{source_file}")')
        # update_info_job.result()
        # print('Update info job finished.')

        replace_tab_job = client.query(f'CALL `{dataset}.replace_tables`()')
        replace_tab_job.result()
        print('Replace tab job finished.')