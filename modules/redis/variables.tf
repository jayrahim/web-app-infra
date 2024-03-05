variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where Redis is to be deployed"
}

variable "redis_subnet_ids" {
  type        = list(string)
  description = "The subnet IDs that comprise the Redis subnet group"
}

variable "replication_group_id" {
  type        = string
  description = "Name of the Redis replication group"
}

variable "project_name" {
  type        = string
  description = "The project name to be used in the value of the Name tag"
}

variable "redis_subnet_cidrs" {
  type        = list(string)
  description = "The CIDRs of the cache subnets"
  default     = []
}