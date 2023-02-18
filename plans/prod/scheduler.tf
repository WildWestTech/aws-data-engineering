module "event-bridge" {
    source  = "../../modules/event-bridge"
    env     = "${var.env}"
    account = "${var.account}"
    region  = "${var.region}"
}