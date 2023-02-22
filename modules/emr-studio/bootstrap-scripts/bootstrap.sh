#!/bin/bash

# Install packages for PySpark
sudo /usr/bin/python3 -m pip install boto3 pandas numpy==1.17.3 scikit-learn

# Install packages for regular Python
sudo /usr/bin/python3 -m ensurepip
sudo /usr/bin/python3 -m pip install boto3 pandas numpy==1.17.3 scikit-learn

# Fix awswrangler compatibility issue with numpy
sudo /usr/bin/python3 -m pip install sudo pip install pyarrow==2 awswrangler

# Download JAR files from S3
aws s3 cp s3://wildwesttech-emr-studio-resources-dev/jar-files/mssql-jdbc-6.4.0.jre8.jar /usr/lib/spark/jars/mssql-jdbc-6.4.0.jre8.jar
aws s3 cp s3://wildwesttech-emr-studio-resources-dev/jar-files/postgresql-42.5.4.jar /usr/lib/spark/jars/postgresql-42.5.4.jar