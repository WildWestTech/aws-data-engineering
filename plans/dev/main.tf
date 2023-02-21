#===========================================================
# helpful commands
# terraform init
# terraform plan
# terraform apply
# terraform force-unlock <lock-id>
#===========================================================
# telling terraform where and how to work with the statefile
# we're storing it in an s3 bucket in aws
#===========================================================
terraform {
    backend "s3" {
        bucket          = "wildwesttech-terraform-backend-state-dev"
        key             = "aws-data-engineering-dev/terraform.tfstate"
        region          = "us-east-1"
        dynamodb_table  = "terraform-state-locking"
        encrypt         = true
        profile         = "251863357540_AdministratorAccess"
    }

}
provider "aws" {
    profile = "${var.profile}"
    region  = "${var.region}"
}

provider "aws" {
    alias   = "management"
    profile = "643000937293_AdministratorAccess"
    region  = "${var.region}"
}

data "aws_ssoadmin_instances" "management" {
  provider = aws.management
}

locals {
  identity_store_id = data.aws_ssoadmin_instances.management.identity_store_ids[0]
}

#===========================================================
# for docker
# we'll use docker for deploying lambdas
#===========================================================
terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
            version = "2.15.0"
        }
    }
}

#===========================================================
# temporary credentials for working with docker
# we'll need this when we deploy our lambdas
#===========================================================
data aws_ecr_authorization_token this {}

provider "docker" {
  host    = "npipe:////.//pipe//docker_engine"
  registry_auth {
    address  = data.aws_ecr_authorization_token.this.proxy_endpoint
    username = data.aws_ecr_authorization_token.this.user_name
    password = data.aws_ecr_authorization_token.this.password
  }
}