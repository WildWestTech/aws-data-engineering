# Medallion Architecture: Bronze, Silver, Gold
resource "aws_s3_bucket" "wildwesttech-bucket" {
  for_each = toset(var.bucket_list)
  bucket = "wildwesttech-${each.value}-${var.env}"
  force_destroy = true
  tags = {
    env        = "${var.env}"
    stage      = "${each.value}"
  }
}

# Let's block external access to the bicket
resource "aws_s3_bucket_public_access_block" "wildwesttech-bucket" {
  for_each = toset(var.bucket_list)
  bucket = aws_s3_bucket.wildwesttech-bucket[each.value].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning on the bucket
resource "aws_s3_bucket_versioning" "wildwesttech-bucket" {
  for_each = toset(var.bucket_list)
  bucket = aws_s3_bucket.wildwesttech-bucket[each.value].id
  versioning_configuration {
    status = "Enabled"
  }
}