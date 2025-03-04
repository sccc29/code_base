resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "main" {
  depends_on = [aws_s3_bucket_ownership_controls.main]

  bucket = aws_s3_bucket.main.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_enabled ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_enabled ? aws_kms_key.mykey[aws_s3_bucket.main.bucket].id : null
    }
  }
}

resource "aws_kms_key" "mykey" {
  for_each                = var.kms_enabled ? toset([var.bucket_name]) : toset([])
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}