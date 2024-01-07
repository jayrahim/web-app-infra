output "rds_sg_id" {
  description = "Security group ID of the RDS instance"
  value       = aws_db_instance.rds.id
}

output "rds_subnet_group_name" {
  description = "Name of the RDS instance's subnet group"
  value       = aws_db_subnet_group.rds_subnet_group.id
}

output "rds_endpoint" {
  description = "The host endpoint of the RDS instance"
  value       = aws_db_instance.rds.address
}

output "efs_sg_id" {
  description = "The ID of the security group of EFS"
  value       = aws_security_group.efs_sg.id
}

output "efs_mount_target_dns_name" {
  description = "The endpoint of the EFS mount target"
  value       = aws_efs_mount_target.efs_mount_target.dns_name
}
