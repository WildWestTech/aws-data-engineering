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
        bucket          = "wildwesttech-terraform-backend-state-prod"
        key             = "aws-data-engineering-prod/terraform.tfstate"
        region          = "us-east-1"
        dynamodb_table  = "terraform-state-locking"
        encrypt         = true
        profile         = "264940530023_AdministratorAccess"
    }

}
provider "aws" {
    profile = "${var.profile}"
    region  = "${var.region}"
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