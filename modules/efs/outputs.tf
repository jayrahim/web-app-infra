output "efs_sg_id" {
  description = "The ID of the security group of EFS"
  value       = aws_security_group.efs_sg.id
}

output "efs_mount_target_dns_names" {
  description = "The endpoints of the EFS mount targets"
  value       = aws_efs_mount_target.efs_mount_targets.*.dns_name
}

output "efs_arn" {
  description = "The ARN of the EFS"
  value       = aws_efs_file_system.efs_fs.arn
}

output "efs_arns_asssociated_with_mount_targets" {
  description = "The ARNs associated with each of the mount targets (should be the same ARN for both)"
  value       = aws_efs_mount_target.efs_mount_targets.*.file_system_arn
}