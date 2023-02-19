# https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-studio-configure.html

module "emr-studio" {
    source  = "../../modules/emr-studio"
    env     = "${var.env}"
    account = "${var.account}"
    region  = "${var.region}"
    identity_store_id = local.identity_store_id
}