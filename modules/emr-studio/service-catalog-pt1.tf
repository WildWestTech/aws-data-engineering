# Creating a Portfolio - A collection of products we create, manage, and make available for end-users in the EMR Studio
resource "aws_servicecatalog_portfolio" "EMR_Cluster_Template_Portfolio" {
  name          = "EMR_Cluster_Template_Portfolio"
  description   = "List of EMR Cluster Templates"
  provider_name = "Andrew McLaughlin"
}

variable "Default_Cluster" {
    type = string
    default = "./cluster-templates/Default_Cluster"
}

# hash the file
locals {
    Default_Cluster_hash = filesha1("${path.module}/${var.Default_Cluster}-${var.env}.yaml")
}

#Upload the cluster template to s3
resource "aws_s3_bucket_object" "Default_Cluster" {
  bucket = "wildwesttech-service-catalog-${var.env}"
  key    = "Default_Cluster-${local.Default_Cluster_hash}.yaml"
  source = "${path.module}/${var.Default_Cluster}-${var.env}.yaml"
  etag   = filemd5("${path.module}/${var.Default_Cluster}-${var.env}.yaml")
}


resource "aws_servicecatalog_product" "Default_Cluster" {
  for_each = toset([local.Default_Cluster_hash])
  name  = "Default_Cluster"
  owner = "Andrew McLaughlin"
  type  = "CLOUD_FORMATION_TEMPLATE"

  provisioning_artifact_parameters {
    template_url  = "https://wildwesttech-service-catalog-${var.env}.s3.amazonaws.com/Default_Cluster-${each.value}.yaml"
    name          = "Default_Cluster"
    description   = "${each.value}"
    type          = "CLOUD_FORMATION_TEMPLATE"     
  }

  depends_on = [
    aws_s3_bucket_object.Default_Cluster,
    local.Default_Cluster_hash
  ]
}


#Product-Portfolio Association
resource "aws_servicecatalog_product_portfolio_association" "Default_Cluster" {
  for_each = toset([local.Default_Cluster_hash])
  portfolio_id = aws_servicecatalog_portfolio.EMR_Cluster_Template_Portfolio.id
  product_id   = aws_servicecatalog_product.Default_Cluster[each.key].id
}

#Launch Constraint
resource "aws_servicecatalog_constraint" "Default_Cluster" {
  for_each = toset([local.Default_Cluster_hash])
  description  = "Allows EMR Studio Users to access cluster templates"
  portfolio_id = aws_servicecatalog_portfolio.EMR_Cluster_Template_Portfolio.id
  product_id   = aws_servicecatalog_product.Default_Cluster[each.key].id
  type         = "LAUNCH"

  parameters = jsonencode({
    "RoleArn" : "arn:aws:iam::${var.account}:role/ClusterTemplateLaunchRole"
  })
}

