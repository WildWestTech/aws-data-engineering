variable "Example_Two_Node_Cluster" {
    type = string
    default = "./cluster-templates/Example_Two_Node_Cluster.yaml"
}

# hash the file
locals {
    Example_Two_Node_Cluster_hash = filesha1("${path.module}/${var.Example_Two_Node_Cluster}")
}

resource "aws_s3_bucket_object" "Example_Two_Node_Cluster" {
  bucket = "wildwesttech-service-catalog-${var.env}"
  key    = "Example_Two_Node_Cluster-${local.Example_Two_Node_Cluster_hash}.yaml"
  source = "${path.module}/${var.Example_Two_Node_Cluster}"
  etag   = filemd5("${path.module}/${var.Example_Two_Node_Cluster}")
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

resource "aws_servicecatalog_product_portfolio_association" "example" {
  for_each = toset([local.Example_Two_Node_Cluster_hash])
  portfolio_id = aws_servicecatalog_portfolio.portfolio.id
  product_id   = aws_servicecatalog_product.cluster-template[each.key].id
}