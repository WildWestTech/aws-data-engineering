module "emr-studio" {
    source  = "../../modules/emr-studio"
    env     = "${var.env}"
    account = "${var.account}"
}