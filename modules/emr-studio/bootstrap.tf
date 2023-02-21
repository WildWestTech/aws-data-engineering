# path to bootstrap folder
variable "bootstrap" {
    type = string
    default = "./bootstrap-scripts/bootstrap.sh"
}

# hash the file
locals {
    bootstrap_hash = filesha1("${path.module}/${var.bootstrap}")
}

# upload the bootstrap script to s3
resource "aws_s3_bucket_object" "bootstrap" {
  bucket = "wildwesttech-emr-studio-resources-${var.env}"
  key    = "/bootstrap-scripts/bootstrap.sh"
  source = "${path.module}/${var.bootstrap}"
  etag   = filemd5("${path.module}/${var.bootstrap}")
}
