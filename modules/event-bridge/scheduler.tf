resource "aws_scheduler_schedule" "alphavantage-kickoff" {
  name       = "alphavantage-kickoff"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(0 8 * * ? *)"
  schedule_expression_timezone = "America/Louisville"

  target {
    arn      = "arn:aws:lambda:${var.region}:${var.account}:function:alphavantage-kickoff-lambda-${var.env}"
    role_arn = "arn:aws:iam::${var.account}:role/scheduler-service-role"
  }

  state = "ENABLED"
}