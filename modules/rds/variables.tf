variable "rds_instance_class" {
  type        = string
  description = "The instance class of the RDS instance"
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  description = "The amount of storage of the RDS instance"
  default     = 5
}

variable "engine" {
  type        = string
  description = "The type of RDS engine (e.g. mysql)"
}

variable "major_engine_version" {
  type        = string
  description = "The version of the RDS engine"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Whether to allow auto minor version upgrades to the engine version"
  default     = true
}

variable "backup_retention_period" {
  type        = number
  description = "The duration to keep an RDS snapshot"
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "The subnet IDs to use for the RDS instance's subnet group"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID the resources are to be deployed in"
}


variable "db_name" {
  type        = string
  description = "The name of the RDS instance"
}

variable "project_name" {
  type        = string
  description = "The name of the project"
  default     = "web-app-infra"
}

variable "app_cidrs" {
  type        = list(string)
  description = "The CIDR blocks of the app subnets"
  default     = []
}