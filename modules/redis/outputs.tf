
output "redis_replication_group_id" {
  description = "The ID of the Redis replication group"
  value       = aws_elasticache_replication_group.redis_rep_group.id
}

output "redis_replication_group_primary_endpoint" {
  description = "The primary endpoint of the Redis replication group"
  value       = aws_elasticache_replication_group.redis_rep_group.primary_endpoint_address
}

output "redis_replication_group_reader_endpoint" {
  description = "The reader endpoint of the Redis replication group"
  value       = aws_elasticache_replication_group.redis_rep_group.reader_endpoint_address
}

output "security_group_id" {
  description = "The Redis replication group's security group Id"
  value       = aws_security_group.redis_sg.id
}

output "redis_subnet_group_ids" {
  description = "The subnets that make up the Redis subnet group"
  value       = aws_elasticache_subnet_group.redis_subnet_group.subnet_ids
}

output "redis_log_group_arn" {
  description = "The log group's ARN"
  value       = aws_cloudwatch_log_group.redis_log_group.arn
}