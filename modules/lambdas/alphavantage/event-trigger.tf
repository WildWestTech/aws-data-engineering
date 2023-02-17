resource "aws_lambda_event_source_mapping" "alphavantage" {
  event_source_arn  = "arn:aws:sqs:us-east-1:${var.account}:alphavantage-queue-${var.env}"
  function_name     = "arn:aws:lambda:us-east-1:${var.account}:function:alphavantage-lambda-${var.env}"
  batch_size        = 1
  enabled           = true
  depends_on = [
    aws_lambda_function.alphavantage-lambda
  ]
}