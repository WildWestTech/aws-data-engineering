module "windows-server-ec2" {
    source      = "../../modules/windows-server-ec2"
    env         = "${var.env}"
    Private-1A  = data.aws_subnet.Private-1A.id
}