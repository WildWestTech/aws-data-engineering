module "mwaa" {
    source      = "../../modules/mwaa"
    env         = "${var.env}"
    account     = "${var.account}"
    Private-1A  = data.aws_subnet.Private-1A.id
    Private-1B  = data.aws_subnet.Private-1B.id
}