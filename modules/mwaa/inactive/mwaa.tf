#========================================================
# AWS Managed Workflows for Apache Airflow
# There are several pre-reqs for this:
# Most will be in the read-me, but pay special attention to the NAT Gateways
# This requires Two NAT Gateways - make sure to tear those down after each lab session
# Approx. 30 minutes to spin-up
#========================================================
resource "aws_mwaa_environment" "mwaa" {
  name                  = "AirFlow"
  source_bucket_arn     = "arn:aws:s3:::wildwesttech-mwaa-${var.env}"
  dag_s3_path           = "dags/"
  plugins_s3_path       = "plugins/"
  requirements_s3_path  = "requirements/"
  execution_role_arn    = "arn:aws:iam::${var.account}:role/mwaa-execution-role"
  min_workers           = 1
  max_workers           = 1
  webserver_access_mode = "PUBLIC_ONLY"
  network_configuration {
    security_group_ids  = [data.aws_security_group.mwaa.id]
    subnet_ids          = [var.Private-1A, var.Private-1B]
  }
  depends_on            = [aws_s3_bucket_object.mwaa]
}