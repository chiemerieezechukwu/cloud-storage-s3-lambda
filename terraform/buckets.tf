resource "aws_s3_bucket" "object_storage_bucket" {
  bucket_prefix = local.bucket_name_prefix
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "object_storage_bucket_encryption" {
  bucket = aws_s3_bucket.object_storage_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "object_storage_bucket_acl" {
  bucket = aws_s3_bucket.object_storage_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "object_storage_bucket_public_access_block" {
  bucket = aws_s3_bucket.object_storage_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
