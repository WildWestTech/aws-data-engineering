# iterate through the docker folder
# hash the contents of each file
# join those hash values, hash the join <-- what the heck??
# basically, i want to rebuild the lambda, any time there is an update to any of the lambda code

# create a variable pointing to where the docker folder lives
variable "alphavantage_folder" {
    type = string
    default = "..\\..\\modules\\lambdas\\alphavantage\\docker-image"
}

# iterate through the folder and hash the contents
locals {
    alphavantage_hash = sha1(join("", [for f in fileset(var.alphavantage_folder, "*"): filesha1("${var.alphavantage_folder}/${f}")]))
}

#==================================================

# create an elastic container repository for the lambda image
resource "aws_ecr_repository" "alphavantage-lambda" {
    name = "alphavantage-lambda-${var.env}"
    force_delete = true
}

# this is where we create the docker image, used for the lambda, then push it up to the ecr
# the big challenge here was versioning.  take a look at the name
# we want to tag the name with the version (defaults to latest)
# versioning could be a very manual process
# now, if we update our lambda code, that code repo is hashed.  i'm using that hash as my version tag
# so when the code changes, the hash changes.  when the hash changes, the lamdbda is re-built and re-deployed

resource "docker_registry_image" "alphavantage-lambda" {
    name = "${aws_ecr_repository.alphavantage-lambda.repository_url}:${local.alphavantage_hash}"
    build {
        context = var.alphavantage_folder
    }
    keep_remotely = false
    depends_on = [
      aws_ecr_repository.alphavantage-lambda
    ]
}

module "lambdas-alphavantage" {
    source          = "../../modules/lambdas/alphavantage"
    env             = "${var.env}"
    account         = "${var.account}"
    region          = "${var.region}"
    lambda_version  = "${local.alphavantage_hash}"
    depends_on      = [
        docker_registry_image.alphavantage-lambda,
        module.sns-sqs
        ]
}