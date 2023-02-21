#!/bin/bash

# Install packages
pip install boto3 awswrangler pandas

# Download and install jars from S3
#aws s3 cp s3://my-bucket/my-jar-file-1.jar /usr/lib/my-jars/
#aws s3 cp s3://my-bucket/my-jar-file-2.jar /usr/lib/my-jars/
