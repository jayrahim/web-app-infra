variable "major_engine_version" {
  type        = string
  description = "The version of the RDS instance"
  default     = "8.0"
}

variable "engine" {
  type        = string
  description = "The enginne of the RDS instance (e.g., mysql, mssql etc.)"
  default     = "mysql"
}

variable "backup_retention_period" {
  type        = number
  description = "The number of days to retain the snapshot"
  default     = 1
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