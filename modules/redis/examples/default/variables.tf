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