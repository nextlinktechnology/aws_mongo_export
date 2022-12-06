import json
import boto3
import env

region = "ap-northeast-1"
instances = [env.INSTANCE_ID]
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    # TODO implement
    action = event["action"]
    
    if action == "start_ec2":
        ec2.start_instances(InstanceIds=instances)
    
        return {
            'statusCode': 200,
            'body': json.dumps('started your instances: ' + str(instances))
        }
    
    if action == "stop_ec2":
        ec2.stop_instances(InstanceIds=instances)
    
        return {
            'statusCode': 200,
            'body': json.dumps('stopped your instances: ' + str(instances))
        }
    
    return {
        'statusCode': 400,
        'body': json.dumps('action is not specified')
    }
