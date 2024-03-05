output "bucket_id" {
  description = "The name of the S3 bucket"
  value       = module.s3.bucket_id
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = module.s3.bucket_domain_name
}