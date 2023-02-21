resource "aws_emr_studio_session_mapping" "DataEngineering" {
  studio_id          = aws_emr_studio.DataEngineering.id
  identity_type      = "GROUP"
  identity_id        = data.aws_identitystore_group.dataengineers.id
  session_policy_arn = "arn:aws:iam::${var.account}:policy/EMRStudio_Advanced_User_Policy"
}
