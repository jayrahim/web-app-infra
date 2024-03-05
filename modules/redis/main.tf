locals {
  default_cache_cidrs = toset(["10.0.128.0/20", "10.0.144.0/20"])
}

resource "aws_security_group" "redis_sg" {
  description = "Security group for the ${var.project_name}-redis cluster"
  name        = "${var.project_name}-redis-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-redis-sg"
  }
}

resource "aws_security_group_rule" "allow_app_sg" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = length(var.redis_subnet_cidrs) > 0 ? var.redis_subnet_cidrs : tolist(local.default_cache_cidrs)
  security_group_id = aws_security_group.redis_sg.id
}

resource "aws_elasticache_parameter_group" "redis_parameter_group" {
  name        = "${var.project_name}-redis-param-group"
  family      = "redis7"
  description = "Parameter group for the ${var.project_name}-redis cluster"

  tags = {
    "Name" = "${var.project_name}-redis-param-group"
  }
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name        = "${var.project_name}-redis-sub-group"
  description = "Subnet group for the Redis replication group"
  subnet_ids  = var.redis_subnet_ids

  tags = {
    "Name" = "${var.project_name}-redis-sub-group"
  }
}

resource "aws_cloudwatch_log_group" "redis_log_group" {
  name              = "${var.project_name}-redis-log-group"
  log_group_class   = "STANDARD"
  retention_in_days = 7

  tags = {
    "Name" = "${var.project_name}-redis-log-group"
  }
}

resource "aws_elasticache_replication_group" "redis_rep_group" {
  automatic_failover_enabled  = true
  auto_minor_version_upgrade  = true
  preferred_cache_cluster_azs = ["us-east-1a", "us-east-1b"]
  replication_group_id        = var.replication_group_id
  description                 = "Replication group for the Redis cluster"
  node_type                   = "cache.t2.micro"
  engine_version              = "7.1"
  num_cache_clusters          = 2
  parameter_group_name        = aws_elasticache_parameter_group.redis_parameter_group.id
  port                        = 6379
  security_group_ids          = [aws_security_group.redis_sg.id]
  multi_az_enabled            = true
  snapshot_retention_limit    = 7
  at_rest_encryption_enabled  = true
  subnet_group_name           = aws_elasticache_subnet_group.redis_subnet_group.name

  log_delivery_configuration {
    destination      = "${var.project_name}-redis-log-group"
    destination_type = "cloudwatch-logs"
    log_type         = "slow-log"
    log_format       = "json"
  }

  log_delivery_configuration {
    destination      = "${var.project_name}-redis-log-group"
    destination_type = "cloudwatch-logs"
    log_type         = "engine-log"
    log_format       = "json"
  }

  tags = {
    "Name" = "${var.project_name}-redis"
  }
}