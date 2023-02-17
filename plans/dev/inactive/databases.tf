module "databases" {
    source = "../../modules/databases"
    env = "${var.env}"
    account = "${var.account}"
    region  ="${var.region}"

    #Postgres
    rds_postgres_allocated_storage      = 20
    rds_postgres_engine_version         = "13.7"
    rds_postgres_instance_class         = "db.t3.micro"
    rds_postgres_deletion_protection    = false
    rds_postgres_skip_final_snapshot    = true

    #Aurora-Postgres: Serverless V1 (older, but good for AppSync)
    #Requires Three AZs
    rds_aurora_pg_engine_version        = "10.18"
    rds_aurora_pg_database_name         = "postgres"
    rds_aurora_pg_min_capacity          = 2
    rds_aurora_pg_max_capacity          = 4
    rds_aurora_pg_deletion_protection   = false
    rds_aurora_pg_skip_final_snapshot   = true
    rds_aurora_pg_zone_1                = "us-east-1a"
    rds_aurora_pg_zone_2                = "us-east-1b"
    rds_aurora_pg_zone_3                = "us-east-1c"
}