# To-Do:
# Create an SNS Topic
# Create an SQS Queue
# Create a Resource Policy, Allowing the SNS Topic to Send Messages to the SQS Queue
# Subscribe the SQS Queue to the SNS Topic
# Set the SQS Queue as the Triggering Event for our AlphaVantage Lambda <-- comment this section out, until 

resource "aws_sns_topic" "alphavantage-topic" {
  name = "alphavantage-topic-${var.env}"
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sqs_queue" "alphavantage-queue" {
  name                       = "alphavantage-queue-${var.env}"
  delay_seconds              = 0
  max_message_size           = 262144 #256 KiB
  message_retention_seconds  = 1209600 #14 days
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = 60
}

resource "aws_sqs_queue_policy" "alphavantage-queue" {
  queue_url = aws_sqs_queue.alphavantage-queue.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "AllowTopicToSendMessages",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.alphavantage-queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.alphavantage-topic.arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sns_topic_subscription" "alphavantage-subscription" {
  topic_arn = aws_sns_topic.alphavantage-topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.alphavantage-queue.arn
}