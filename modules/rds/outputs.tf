output "rds_sg_id" {
  description = "Security group ID of the RDS instance"
  value       = aws_security_group.rds_sg.id
}

output "rds_subnet_group_name" {
  description = "Name of the RDS instance's subnet group"
  value       = aws_db_subnet_group.rds_subnet_group.id
}

output "rds_endpoint" {
  description = "The host endpoint of the RDS instance"
  value       = aws_db_instance.rds.address
}

output "rds_id" {
  description = "The ID of the RDS instance"
  value       = aws_db_instance.rds.id
}

output "parameter_group_id" {
  description = "The RDS parameter group Id"
  value       = aws_db_parameter_group.rds_parameter_group.id

}

output "option_group_id" {
  description = "The ID of the RDS option group"
  value       = aws_db_option_group.rds_option_group.id
}