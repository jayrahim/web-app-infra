variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where EFS will be deployed"
}

variable "project_name" {
  type        = string
  description = "The name of the project"
  default     = "web-app-infra"
}

variable "app_subnet_ids" {
  type        = list(string)
  description = "The app subnet Ids"
  default     = []
}