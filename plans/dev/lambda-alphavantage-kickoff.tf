# iterate through the docker folder
# hash the contents of each file
# join those hash values, hash the join <-- what the heck??
# basically, i want to rebuild the lambda, any time there is an update to any of the lambda code

# create a variable pointing to where the docker folder lives
variable "alphavantage-kickoff_folder" {
    type = string
    default = "..\\..\\modules\\lambdas\\alphavantage-kickoff\\docker-image"
}

# iterate through the folder and hash the contents
locals {
    alphavantage-kickoff_hash = sha1(join("", [for f in fileset(var.alphavantage-kickoff_folder, "*"): filesha1("${var.alphavantage-kickoff_folder}/${f}")]))
}

#==================================================

# create an elastic container repository for the lambda image
resource "aws_ecr_repository" "alphavantage-kickoff-lambda" {
    name = "alphavantage-kickoff-lambda-${var.env}"
    force_delete = true
}

# this is where we create the docker image, used for the lambda, then push it up to the ecr
# the big challenge here was versioning.  take a look at the name
# we want to tag the name with the version (defaults to latest)
# versioning could be a very manual process
# now, if we update our lambda code, that code repo is hashed.  i'm using that hash as my version tag
# so when the code changes, the hash changes.  when the hash changes, the lamdbda is re-built and re-deployed

resource "docker_registry_image" "alphavantage-kickoff-lambda" {
    name = "${aws_ecr_repository.alphavantage-kickoff-lambda.repository_url}:${local.alphavantage-kickoff_hash}"
    build {
        context = var.alphavantage-kickoff_folder
    }
    keep_remotely = false
    depends_on = [
      aws_ecr_repository.alphavantage-kickoff-lambda
    ]
}

module "lambdas-alphavantage-kickoff" {
    source          = "../../modules/lambdas/alphavantage-kickoff"
    env             = "${var.env}"
    account         = "${var.account}"
    region          = "${var.region}"
    lambda_version  = "${local.alphavantage-kickoff_hash}"
    depends_on      = [
        docker_registry_image.alphavantage-kickoff-lambda,
        module.sns-sqs
        ]
}