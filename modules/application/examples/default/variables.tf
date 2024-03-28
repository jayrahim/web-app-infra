variable "app_lb_name" {
  type        = string
  description = "The name of the internal applicaiton load balancer"
}

variable "web_server_prefix" {
  type        = string
  description = "The the prefix used to name web server resources"
}

variable "app_server_prefix" {
  type        = string
  description = "The the prefix used to name app server resources"
}