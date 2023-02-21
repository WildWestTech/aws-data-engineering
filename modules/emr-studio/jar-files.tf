# path to bootstrap folder
variable "jar-files" {
    type = string
    default = "./jar-files"
}

# upload jar files
resource "aws_s3_bucket_object" "jar-files" {
  for_each = fileset("${path.module}/${var.jar-files}", "*")
  bucket   = "wildwesttech-emr-studio-resources-${var.env}"
  key      = "/jar-files/${each.value}"
  source   = "${path.module}/${var.jar-files}/${each.value}"
  etag     = filemd5("${path.module}/${var.jar-files}/${each.value}")
}