resource "aws_s3_bucket_object" "mwaa" {
  for_each      = toset(["dags/","plugins/","requirements/"])
  bucket        = "wildwesttech-mwaa-${var.env}"
  key           = each.value
  content_type  = "application/x-directory"
}