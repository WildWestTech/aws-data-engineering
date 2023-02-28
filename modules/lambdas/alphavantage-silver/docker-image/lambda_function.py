import boto3
import json
import pandas as pd
from urllib.parse import unquote

def lambda_handler(event, context):
    out = {}
    try:
        # Parse S3 Trigger Event
        bucket = event['Records'][0]['s3']['bucket']['name']
        key = event['Records'][0]['s3']['object']['key']

        # fix any url encoded items: = and %3D
        key = unquote(key) 
        symbol = key.split("/")[-1].replace('.json','')
        
        out['bucket'] = bucket
        out['key'] = key

        # split the file into bucket and key, load the object
        # bucket, key = "wildwesttech-bronze-dev", "alphavantage_bronze/SPY/dataload=20230217/SPY.json"
        s3 = boto3.resource('s3')
        obj = s3.Object(bucket, key)
        data = json.load(obj.get()['Body'])

        # after viewing the data, grab the Time Series data to work with
        TimeSeries = data['Time Series (5min)']
        
        # transpose the rows and columns for a cleaner dataframe
        df = pd.DataFrame.from_dict(TimeSeries).transpose()
        
        # let's rename the columns
        columns={'index': 'refresh_datetime',
                '1. open':'open',
                '2. high':'high',
                '3. low':'low',
                '4. close':'close',
                '5. volume':'volume'}
        
        # reset the index and rename columns
        df = df.reset_index().rename(columns=columns)
        df['symbol'] = symbol

        # transition from bronze to silver
        bucket = bucket.replace('bronze','silver')
        key    = key.replace('bronze','silver')
        key    = key.replace('.json','.csv')

        # write back to s3
        df.to_csv(f's3://{bucket}/{key}', index=False)

    except Exception as e:
        out['error'] = e
        out['completion-status'] = 'failure'
    finally:
        print(out)