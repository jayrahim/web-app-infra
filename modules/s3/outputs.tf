output "bucket_id" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.storage_and_backup.id
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.storage_and_backup.bucket_domain_name
}