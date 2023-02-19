variable "Example_Two_Node_Cluster" {
    type = string
    default = "./cluster-templates/Example_Two_Node_Cluster.yaml"
}

data "template_file" "example" {
  template = file("${path.module}/${var.Example_Two_Node_Cluster}")
  vars = {
    subnet_id      = var.subnet_id
    LogUri         = var.LogUri
  }
}

locals {
  rendered_file_contents            = data.template_file.example.rendered
  Example_Two_Node_Cluster_hash     = filemd5(local.rendered_file_contents)
}

resource "aws_s3_bucket_object" "Example_Two_Node_Cluster" {
  bucket = "wildwesttech-service-catalog-${var.env}"
  key    = "Example_Two_Node_Cluster-${local.Example_Two_Node_Cluster_hash}.yaml"
  source = data.template_file.example.rendered
  etag   = filemd5(data.template_file.example.rendered)
}


resource "aws_servicecatalog_portfolio" "portfolio" {
  name          = "Cluster Template Portfolio"
  description   = "List of my organizations apps"
  provider_name = "Andrew"
}

# Known Issue/Versioning: 
# https://github.com/hashicorp/terraform-provider-aws/issues/19506
resource "aws_servicecatalog_product" "cluster-template" {
  for_each = toset([local.Example_Two_Node_Cluster_hash])
  name  = "Example_Two_Node_Cluster-${each.value}"
  owner = "Andrew"
  type  = "CLOUD_FORMATION_TEMPLATE"

  provisioning_artifact_parameters {
    template_url = "https://wildwesttech-service-catalog-${var.env}.s3.amazonaws.com/Example_Two_Node_Cluster-${each.value}.yaml"
    type         = "CLOUD_FORMATION_TEMPLATE"
    }
  depends_on = [
    local.Example_Two_Node_Cluster_hash,
    aws_s3_bucket_object.Example_Two_Node_Cluster
  ]
}