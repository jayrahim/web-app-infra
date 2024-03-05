output "efs_sg_id" {
  description = "The ID of the security group of EFS"
  value       = module.efs.efs_sg_id
}

output "efs_mount_target_dns_names" {
  description = "The endpoints of the EFS mount targets"
  value       = module.efs.efs_mount_target_dns_names
}

output "efs_arn" {
  description = "The ARN of the EFS"
  value       = module.efs.efs_arn
}

output "efs_arns_asssociated_with_mount_targets" {
  description = "The ARNs associated with each of the mount targets (should be the same ARN for both)"
  value       = module.efs.efs_arns_asssociated_with_mount_targets
}