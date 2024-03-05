
resource "aws_s3_bucket" "storage_and_backup" {
  bucket        = "${var.project_name}-s3"
  force_destroy = true

  tags = {
    Name = "${var.project_name}-s3"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encyrption" {
  bucket = aws_s3_bucket.storage_and_backup.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}