#serverless v1
resource "aws_rds_cluster" "aurora_pg" {
  cluster_identifier      = "aurora-pg-serverless-v1-${var.env}"
  engine                  = "aurora-postgresql"
  engine_mode             = "serverless"
  engine_version          = "${var.rds_aurora_pg_engine_version}"
  availability_zones      = ["${var.rds_aurora_pg_zone_1}","${var.rds_aurora_pg_zone_2}","${var.rds_aurora_pg_zone_3}"] #requires 3 zones
  database_name           = "${var.rds_aurora_pg_database_name}"
  master_username         = "postgres"
  master_password         = "${random_password.aurora_pg_pwd.result}"
  backup_retention_period = 7
  preferred_backup_window = "08:00-08:30" #don't really care about this
  vpc_security_group_ids  = [data.aws_security_group.database_security_group.id]
  db_subnet_group_name    = "database_subnet_group"
  enable_http_endpoint    = true
  storage_encrypted       = true
  port                    = 5432
  copy_tags_to_snapshot   = true
  deletion_protection     = var.rds_aurora_pg_deletion_protection #flip once done testing
  skip_final_snapshot     = var.rds_aurora_pg_skip_final_snapshot #flip once done testing


  scaling_configuration {
    min_capacity = var.rds_aurora_pg_min_capacity
    max_capacity = var.rds_aurora_pg_max_capacity
    auto_pause   = false
    seconds_until_auto_pause = 300
    timeout_action = "RollbackCapacityChange"
  }
}

#=======================================================
# Random Password For Aurora Postgres
#=======================================================
resource "random_password" "aurora_pg_pwd" {
  length           = 40
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
#=======================================================
# Store Credentials In Secrets Manager
#=======================================================
resource "aws_secretsmanager_secret" "aurora_pg" {
  name = "aurora_pg_secret"
  description = "master password and configuration for aurora_pg database"
  recovery_window_in_days = 0 #allow for immediate deletion
}
#=======================================================
# Log Database Credential To Secrets Manager
#=======================================================
resource "aws_secretsmanager_secret_version" "aurora_pg_secret" {
  secret_id     = aws_secretsmanager_secret.aurora_pg.id
  secret_string = <<EOF
  {
    "username":      "${aws_rds_cluster.aurora_pg.master_username}",
    "password":      "${random_password.aurora_pg_pwd.result}",
    "endpoint":      "${aws_rds_cluster.aurora_pg.endpoint}",
    "port":          "${aws_rds_cluster.aurora_pg.port}",
    "database_name": "${aws_rds_cluster.aurora_pg.database_name}"
  }
    EOF
}