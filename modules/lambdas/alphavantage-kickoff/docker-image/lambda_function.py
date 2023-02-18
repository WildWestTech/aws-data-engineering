import boto3
import json
import os

def lambda_handler(event, context):
    out = {}
    try:
    # Get Environment Variables
        env     = os.environ['env']
        region  = os.environ['region']
        account = os.environ['account']
    # Create Session for SNS
        session = boto3.session.Session()
        sns = session.client("sns",region_name=region)
    # List of Stock Symbols to Send to the SNS Topic
        symbols = ['SPY','DIA','ONEQ']
        for symbol in symbols:
            message = {"symbol":f"{symbol}"}
            response = sns.publish(
                TopicArn=f'arn:aws:sns:us-east-1:{account}:alphavantage-topic-{env}',
                Message=json.dumps({'default': json.dumps(message)}),
                MessageStructure='json'
            )
            out[symbol] = 'success'
    except Exception as e:
        out['error'] = e
    finally:
        print(out)