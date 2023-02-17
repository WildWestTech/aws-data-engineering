#=======================================================
# Free-Tier Postgres ec2 Instance
#=======================================================
resource "aws_db_instance" "postgres" {
  identifier              = "postgres-free-tier-${var.env}"
  storage_type            = "gp2"
  engine                  = "postgres"
  db_subnet_group_name    = "database_subnet_group"
  username                = "postgres"
  password                = "${random_password.postgres_pwd.result}"
  allocated_storage       =  var.rds_postgres_allocated_storage
  engine_version          = "${var.rds_postgres_engine_version}"
  instance_class          = "${var.rds_postgres_instance_class}"
  db_name                 = "postgres"
  vpc_security_group_ids  = [data.aws_security_group.database_security_group.id]
  deletion_protection     =  var.rds_postgres_deletion_protection
  skip_final_snapshot     =  var.rds_postgres_skip_final_snapshot
}
#=======================================================
# Random Password For Postgres
#=======================================================
resource "random_password" "postgres_pwd" {
  length           = 40
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
#=======================================================
# Store Credentials In Secrets Manager
#=======================================================
resource "aws_secretsmanager_secret" "postgres" {
  name = "postgres-secret"
  description = "master password and configuration for postgres database"
  recovery_window_in_days = 0 #allow for immediate deletion
}
#=======================================================
# Log Database Credential To Secrets Manager
#=======================================================
resource "aws_secretsmanager_secret_version" "postgres-secret" {
  secret_id     = aws_secretsmanager_secret.postgres.id
  secret_string = <<EOF
  {
    "username": "${aws_db_instance.postgres.username}",
    "password": "${random_password.postgres_pwd.result}",
    "address":  "${aws_db_instance.postgres.address}",
    "endpoint": "${aws_db_instance.postgres.endpoint}",
    "port":     "${aws_db_instance.postgres.port}",
    "db_name":  "${aws_db_instance.postgres.db_name}"
  }
    EOF
}