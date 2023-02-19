resource "aws_emr_studio_session_mapping" "EMR-Studio" {
  studio_id          = aws_emr_studio.EMR-Studio.id
  identity_type      = "GROUP"
  identity_id        = data.aws_identitystore_group.admins.id
  session_policy_arn = "arn:aws:iam::${var.account}:policy/emr-advanced-user-policy"
}