#=======================================================
# Random Password For Postgres
#=======================================================
resource "random_password" "windows_server_pwd" {
  length           = 40
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
#=======================================================
# Store Credentials In Secrets Manager
#=======================================================
resource "aws_secretsmanager_secret" "windows_server" {
  name = "windows_server_secret"
  description = "master password for windows server"
  recovery_window_in_days = 0 #allow for immediate deletion
}
#=======================================================
# Log Database Credential To Secrets Manager
#=======================================================
resource "aws_secretsmanager_secret_version" "windows_server_secret" {
  secret_id     = aws_secretsmanager_secret.windows_server.id
  secret_string = <<EOF
  {
    "password": "${random_password.windows_server_pwd.result}"
  }
    EOF
}