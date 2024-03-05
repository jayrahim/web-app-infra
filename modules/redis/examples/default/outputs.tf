
output "redis_replication_group_id" {
  description = "The ID of the Redis replication group"
  value       = module.redis.redis_replication_group_id
}

output "redis_replication_group_primary_endpoint" {
  description = "The primary endpoint of the Redis replication group"
  value       = module.redis.redis_replication_group_primary_endpoint
}

output "redis_replication_group_reader_endpoint" {
  description = "The reader endpoint of the Redis replication group"
  value       = module.redis.redis_replication_group_reader_endpoint
}

output "security_group_id" {
  description = "The Redis replication group's security group Id"
  value       = module.redis.security_group_id
}

output "redis_subnet_group_ids" {
  description = "The subnets that make up the Redis subnet group"
  value       = module.redis.redis_subnet_group_ids
}

output "redis_log_group_arn" {
  description = "The log group's ARN"
  value       = module.redis.redis_log_group_arn
}