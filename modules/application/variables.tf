variable "vpc_id" {
  type        = string
  description = "The Id of the VPC where resources will be deployed"
}

variable "web_subnet_ids" {
  type        = list(string)
  description = "The public subnet Ids"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "The public subnet Ids"
}

variable "app_subnet_ids" {
  type        = list(string)
  description = "The app subnet Ids"
}

variable "app_lb_name" {
  type        = string
  description = "The name of the internal application load balancer"
  default     = "app-server-lb"
}

variable "backend_port" {
  type        = number
  description = "The port number of the backend server"
  default     = 5000
}

variable "region" {
  type        = string
  description = "The region where the resources are to be deployed"
  default     = "us-east-1"
}

variable "web_server_prefix" {
  type        = string
  description = "The name prefix used to name web server resources"
  default     = "web-server"
}
variable "app_server_prefix" {
  type        = string
  description = "The name prefix used to name app server resources"
  default     = "app-server"
}