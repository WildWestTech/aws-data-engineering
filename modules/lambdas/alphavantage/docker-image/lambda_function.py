import requests
import boto3
import json
import ast
import os
import pytz
from datetime import datetime

def lambda_handler(event, context):
    out = {}
    try:
    # Set the environment variables
        env     = os.environ['env']
        region  = os.environ['region']
        account = os.environ['account']
    # Prep Date Parts For s3 Hierarchy
        EST  = pytz.timezone('America/Louisville')
        date = datetime.now(EST).strftime('%Y%m%d')
    # Parse the Event
        receiptHandle = event['Records'][0]['receiptHandle']
        message = json.loads(event['Records'][0]['body'])['Message']
        symbol  = json.loads(message)['symbol']
    # Secrets Manager for AlphaVantage - secret was created manually in console
        session     = boto3.session.Session()
        client      = session.client(service_name='secretsmanager',region_name=region)
        response    = client.get_secret_value(SecretId='AlphaVantage')
        secret      = json.loads(response['SecretString'])
        out['get-secret'] = 'success'
    # Extract API Key
        apikey      = secret['apikey']
        function    = 'TIME_SERIES_INTRADAY'
        interval    = '5min'
    # Call API
        url = f'https://www.alphavantage.co/query?function={function}&symbol={symbol}&interval={interval}&apikey={apikey}'
        r = requests.get(url)
        data = r.json()
        out['call-api'] = 'success'
    # Write to s3    
        s3 = boto3.client('s3')
        Key=f"alphavantage_bronze/{symbol}/dataload={date}/{symbol}.json"
        s3.put_object(
            Body= json.dumps(data), 
            Bucket=f'wildwesttech-bronze-{env}',
            Key=Key
        )
        out['load-s3'] = 'success'
        out['completion-status'] = 'success'
    # Clean Up the Queue - Delete The Triggering Message
        queue_url = f'https://sqs.{region}.amazonaws.com/{account}/alphavantage-queue-{env}'
        client = boto3.client('sqs',region_name='us-east-1')
        response = client.delete_message(
            QueueUrl=queue_url,
            ReceiptHandle=receiptHandle
        )
    except Exception as e:
        out['error'] = e
        out['completion-status'] = 'failure'
    finally:
        print(out)