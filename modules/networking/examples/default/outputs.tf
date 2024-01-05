output "vpc_id" {
  description = "The VPC ID"
  value       = module.networking.vpc_id
}
output "public_subnet_ids" {
  description = "The VPC ID"
  value       = module.networking.public_subnet_ids
}
output "web_subnet_ids" {
  description = "The VPC ID"
  value       = module.networking.web_subnet_ids
}
output "app_subnet_ids" {
  description = "The VPC ID"
  value       = module.networking.app_subnet_ids
}
output "db_subnet_ids" {
  description = "The VPC ID"
  value       = module.networking.db_subnet_ids
}
output "igw_id" {
  description = "The Internet Gateway ID"
  value       = module.networking.igw_id
}
output "nat_gw_ids" {
  description = "The NAT Gateway IDs"
  value       = module.networking.nat_gw_ids
}

output "nat_gw_eips" {
  description = "Public IPs of the NAT Gateways"
  value       = module.networking.nat_gw_eips
}