module "airflow-ec2" {
    source      = "../../modules/airflow-ec2"
    env         = "${var.env}"
    account     = "${var.account}"
    Private-1A  = data.aws_subnet.Private-1A.id
}