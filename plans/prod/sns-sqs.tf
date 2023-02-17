module "sns-sqs" {
    source  = "../../modules/sns-sqs"
    env     = "${var.env}"
}