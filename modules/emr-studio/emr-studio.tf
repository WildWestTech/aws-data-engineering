resource "aws_emr_studio" "DataEngineering" {
  auth_mode                   = "SSO"
  default_s3_location         = "s3://wildwesttech-emr-studio-workspace-${var.env}"
  engine_security_group_id    =  data.aws_security_group.emr_engine_security_group.id
  workspace_security_group_id =  data.aws_security_group.emr_workspace_security_group.id
  name                        = "DataEngineering-${var.env}"
  service_role                = "arn:aws:iam::${var.account}:role/EMRStudio_Service_Role"
  user_role                   = "arn:aws:iam::${var.account}:role/EMRStudio_User_Role"
  subnet_ids                  = [data.aws_subnet.Private-1A.id]
  vpc_id                      =  data.aws_vpc.main.id
}

#studio is in                  'subnet-07c7578426ed4f1f1' 'Private-1C'
#cluster went automatically to 'subnet-07c7578426ed4f1f1' 'Private-1C'
#was previously hard-coding to 'subnet-099efa89d64903f8b'