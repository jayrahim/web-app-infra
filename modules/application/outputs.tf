output "web_lb_dns_name" {
  description = "The DNS name of the web load balancer"
  value       = aws_lb.web_lb.dns_name
}

output "web_target_group_name" {
  description = "The name of the web lb's target group"
  value       = aws_lb_target_group.web_load_balancer_tg.name
}

output "image_id" {
  description = "The Id of the Ubuntu image"
  value       = data.aws_ami.selected.image_id
}


output "web_server_asg_min" {
  description = "The min size of the web autoscaling group"
  value       = aws_autoscaling_group.web_server_asg.min_size
}

output "web_server_asg_desired" {
  description = "The deesired capacity of the web autoscaling group"
  value       = aws_autoscaling_group.web_server_asg.desired_capacity
}

output "web_server_asg_max" {
  description = "The max size of the web autoscaling group"
  value       = aws_autoscaling_group.web_server_asg.max_size
}

output "web_server_role" {
  description = "The name of the web server role"
  value       = aws_iam_role.web_server_role.name
}

output "web_server_profile" {
  description = "The name of the web server instance profile"
  value       = aws_iam_instance_profile.web_server_profile.name
}

output "app_server_role" {
  description = "The name of the app server role"
  value       = aws_iam_role.app_server_role.name
}

output "app_server_profile" {
  description = "The name of the app server instance profile"
  value       = aws_iam_instance_profile.app_server_profile.name
}

output "app_lb_dns_name" {
  description = "The DNS name of the app load balancer"
  value       = aws_lb.app_lb.dns_name
}


output "app_target_group_name" {
  description = "The name of the app lb's target group"
  value       = aws_lb_target_group.app_load_balancer_tg.name
}

output "app_server_asg_min" {
  description = "The min size of the app autoscaling group"
  value       = aws_autoscaling_group.app_server_asg.min_size
}

output "app_server_asg_desired" {
  description = "The desired capacity of the app autoscaling group"
  value       = aws_autoscaling_group.app_server_asg.desired_capacity
}

output "app_server_asg_max" {
  description = "The max size of the app autoscaling group"
  value       = aws_autoscaling_group.app_server_asg.max_size
}