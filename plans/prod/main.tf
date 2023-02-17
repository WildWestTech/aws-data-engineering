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