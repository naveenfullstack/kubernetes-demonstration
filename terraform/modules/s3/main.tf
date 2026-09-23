# ---------------------------------------------------------
# S3 Bucket
# ---------------------------------------------------------

resource "aws_s3_bucket" "othm_assets" {
  bucket = "${var.name}-assets-${var.envirement}"

  tags = {
    Name        = var.name
    Environment = var.envirement
  }
}

# Block S3 Public Access

resource "aws_s3_bucket_public_access_block" "othm_assets" {
  bucket = aws_s3_bucket.othm_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}