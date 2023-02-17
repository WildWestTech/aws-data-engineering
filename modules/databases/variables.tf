#================================================
# General Variables
#================================================
variable "env" {
  type = string
}

variable "account" {
  type = string
}

variable "region" {
  type = string
}
#================================================
# RDS Postgres Specific Variables
#================================================
variable "rds_postgres_allocated_storage" {
  type = number
}

variable "rds_postgres_engine_version" {
  type = string
}

variable "rds_postgres_instance_class" {
  type = string
}

variable "rds_postgres_deletion_protection" {
  type = bool
}

variable "rds_postgres_skip_final_snapshot" {
  type = bool
}

#================================================
# RDS Aurora Postgres Specific Variables
#================================================
variable "rds_aurora_pg_engine_version" {
  type = string
}

variable "rds_aurora_pg_database_name" {
  type = string
}

variable "rds_aurora_pg_min_capacity" {
  type = number
}

variable "rds_aurora_pg_max_capacity" {
  type = number
}

variable "rds_aurora_pg_deletion_protection" {
  type = bool
}

variable "rds_aurora_pg_skip_final_snapshot" {
  type = bool
}

variable "rds_aurora_pg_zone_1" {
  type = string
}

variable "rds_aurora_pg_zone_2" {
  type = string
}

variable "rds_aurora_pg_zone_3" {
  type = string
}