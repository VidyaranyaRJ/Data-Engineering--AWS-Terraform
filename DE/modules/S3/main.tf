resource "aws_s3_bucket" "examplebucket" {
  bucket = var.bucket_name
}

resource "aws_s3_object" "examplebucket_object" {
  key    = var.key
  bucket = aws_s3_bucket.examplebucket.id
  source = var.path
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.examplebucket.id

  block_public_acls       = var.true_false
  block_public_policy     = var.true_false
  ignore_public_acls      = var.true_false
  restrict_public_buckets = var.true_false
}
