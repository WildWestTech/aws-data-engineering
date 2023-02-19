resource "aws_emr_studio" "EMR-Studio" {
  auth_mode                   = "SSO"
  default_s3_location         = "s3://wildwesttech-emr-studio-workspace-${var.env}"
  engine_security_group_id    =  data.aws_security_group.emr_engine_security_group.id
  name                        = "EMR-Studio-${var.env}"
  service_role                = "arn:aws:iam::${var.account}:role/emr-studio-service-role"
  subnet_ids                  = [data.aws_subnet.Private-1A.id,
                                 data.aws_subnet.Private-1B.id,
                                 data.aws_subnet.Private-1C.id]
  vpc_id                      =  data.aws_vpc.main.id
  workspace_security_group_id =  data.aws_security_group.emr_workspace_security_group.id
  user_role                   = "arn:aws:iam::${var.account}:role/emr-studio-user-role"
}