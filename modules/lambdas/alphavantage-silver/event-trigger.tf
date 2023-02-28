resource "aws_s3_bucket_notification" "bucket_trigger" {
    bucket = "wildwesttech-bronze-${var.env}"

    lambda_function {
        lambda_function_arn = "${aws_lambda_function.alphavantage-silver-lambda.arn}"
        events              = ["s3:ObjectCreated:*"]
        filter_prefix       = "alphavantage_bronze/"
        filter_suffix       = ".json"
    }
    depends_on = [
      aws_lambda_function.alphavantage-silver-lambda
    ]
}

resource "aws_lambda_permission" "bucket_trigger" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.alphavantage-silver-lambda.arn}"
  principal = "s3.amazonaws.com"
  source_arn = "arn:aws:s3:::wildwesttech-bronze-${var.env}"
}