resource "aws_lambda_function" "alphavantage-silver-lambda" {
  function_name   = "alphavantage-silver-lambda-${var.env}"
  role            = "arn:aws:iam::${var.account}:role/lambda-service-role"
  package_type    = "Image"
  image_uri       = "${var.account}.dkr.ecr.${var.region}.amazonaws.com/alphavantage-silver-lambda-${var.env}:${var.lambda_version}"
  timeout         = 15
  environment {
    variables = {
      env     = "${var.env}"
      region  = "${var.region}"
      account = "${var.account}"
    }
  }
}