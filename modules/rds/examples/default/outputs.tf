output "rds_sg_id" {
  description = "Security group ID of the RDS instance"
  value       = module.rds.rds_sg_id
}

output "rds_subnet_group_name" {
  description = "Name of the RDS instance's subnet group"
  value       = module.rds.rds_subnet_group_name
}

output "rds_endpoint" {
  description = "The host endpoint of the RDS instance"
  value       = module.rds.rds_endpoint
}

output "rds_id" {
  description = "The ID of the RDS instance"
  value       = module.rds.rds_id
}

output "parameter_group_id" {
  description = "The RDS parameter group Id"
  value       = module.rds.parameter_group_id

}

output "option_group_id" {
  description = "The ID of the RDS option group"
  value       = module.rds.option_group_id
}
