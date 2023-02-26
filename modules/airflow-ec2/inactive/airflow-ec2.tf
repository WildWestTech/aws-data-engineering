resource "aws_instance" "airflow" {
  ami                   = "ami-0da95e86fd9a9fdb8"
  instance_type         = "t2.small"
  key_name              = "airflow-pem-keys-${var.env}"
  security_groups       = [data.aws_security_group.airflow_ec2_security_group.id]
  subnet_id             = "${var.Private-1A}"
  iam_instance_profile  = "airflow-ec2-service-role"
  tags = {
    Name = "airflow"
  }
}