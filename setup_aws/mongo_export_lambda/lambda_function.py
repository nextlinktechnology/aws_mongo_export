import json
import os
import urllib3
import time
from urllib3.util import Timeout
import env

vmip = env.LOCAL_IP
vmport = '8080'
region = 'ap-northeast-1'
secret = env.SECRET

def check_hello(trial=1):
    http = urllib3.PoolManager()
    try:
        response = http.request('GET', f'{vmip}:{vmport}/', timeout=Timeout(total=1))
        if response.data != b'<p>Hello, World!</p>':
            raise Exception("not correctly response")
    except:
        print(f'fail count : {str(trial)}, wait {str(2**trial)} secs')
        time.sleep(2**trial)
        next_trial = trial + 1
        if next_trial <= 5:
            return check_hello(trial=next_trial)
        else:
            return "fail"
    return "success"

def call_custom_export(year_month):
    http = urllib3.PoolManager()
    response = http.request('POST', f'{vmip}:{vmport}/init_work', fields={"secret":secret, "year_month":year_month})
    return response.data

def call_now_export():
    http = urllib3.PoolManager()
    response = http.request('POST', f'{vmip}:{vmport}/init_work_now', fields={"secret":secret})
    return response.data

def call_last_export():
    http = urllib3.PoolManager()
    response = http.request('POST', f'{vmip}:{vmport}/init_work_last', fields={"secret":secret})
    return response.data

def lambda_handler(event, context):
    action = event["action"]
    check_response = check_hello()
    if check_response == "fail":
        return {
            'statusCode': 400,
            'body': json.dumps('no respond from app instance')
        }

    if action == "call_custom":
        year_month = event["year_month"]
        call_response = call_custom_export(year_month)
        return {
            'statusCode': 200,
            'body': json.dumps(str(call_response))
        }
    
    if action == "call_now":
        call_response = call_now_export()
        return {
            'statusCode': 200,
            'body': json.dumps(str(call_response))
        }
    
    if action == "call_last":
        call_response = call_last_export()
        return {
            'statusCode': 200,
            'body': json.dumps(str(call_response))
        }

    return {
        'statusCode': 400,
        'body': json.dumps('action is not specified')
    }
