output "web_lb_dns_name" {
  description = "The DNS name of the web load balancer"
  value       = module.application.web_lb_dns_name
}

output "web_target_group_name" {
  description = "The name of the web lb's target group"
  value       = module.application.web_target_group_name
}

output "web_server_role" {
  description = "The name of the web server role"
  value       = module.application.web_server_role
}

output "web_server_profile" {
  description = "The name of the web server instance profile"
  value       = module.application.web_server_profile
}

output "image_id" {
  description = "The Id of the Ubuntu image"
  value       = module.application.image_id
}

output "web_server_asg_min" {
  description = "The min size of the web autoscaling group"
  value       = module.application.web_server_asg_min
}

output "web_server_asg_desired" {
  description = "The deesired capacity of the web autoscaling group"
  value       = module.application.web_server_asg_desired
}

output "web_server_asg_max" {
  description = "The max size of the web autoscaling group"
  value       = module.application.web_server_asg_max
}

output "app_lb_dns_name" {
  description = "The DNS name of the app load balancer"
  value       = module.application.app_lb_dns_name
}

output "app_target_group_name" {
  description = "The name of the app lb's target group"
  value       = module.application.app_target_group_name
}

output "app_server_role" {
  description = "The name of the app server role"
  value       = module.application.app_server_role
}

output "app_server_profile" {
  description = "The name of the app server instance profile"
  value       = module.application.app_server_profile
}

output "app_server_asg_min" {
  description = "The min size of the app autoscaling group"
  value       = module.application.app_server_asg_min
}

output "app_server_asg_desired" {
  description = "The desired capacity of the app autoscaling group"
  value       = module.application.app_server_asg_desired
}

output "app_server_asg_max" {
  description = "The max size of the app autoscaling group"
  value       = module.application.app_server_asg_max
}