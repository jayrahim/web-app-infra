output "vpc_id" {
  description = "The VPC Id"
  value       = aws_vpc.web_app.id
}

output "route_table_ids" {
  description = "The route table Ids"
  value       = aws_route_table.route_tables.*.id
}

output "default_route_states" {
  description = "The state of the default routes"
  value       = aws_route.default_routes.*.state
}

output "public_rtb_public_subnets_association_id" {
  description = "The association Id for the public route table and the public subnets"
  value       = aws_route_table_association.public_rtb_public_subnets.*.id
}

output "public_rtb_web_subnets_association_id" {
  description = "The association Id for the public route table and the web subnets"
  value       = aws_route_table_association.public_rtb_web_subnets.*.id
}

output "private_rtb_app_subnets_association_id" {
  description = "The association Id for the private route table and the app subnets"
  value       = aws_route_table_association.private_rtb_app_subnets.*.id
}

output "private_rtb_db_subnets_association_id" {
  description = "The association Id for the private route table and the db subnets"
  value       = aws_route_table_association.private_rtb_db_subnets.*.id
}

output "private_rtb_cache_association_id" {
  description = "The association Id for the private route table and the cache subnets"
  value       = aws_route_table_association.private_rtb_cache_subnets.*.id
}

output "public_subnet_ids" {
  description = "Public subnet Ids"
  value       = aws_subnet.public.*.id
}

output "web_subnet_ids" {
  description = "Web subnet Ids"
  value       = aws_subnet.web.*.id
}

output "app_subnet_ids" {
  description = "App subnet Ids"
  value       = aws_subnet.app.*.id
}

output "db_subnet_ids" {
  description = "DB subnet Ids"
  value       = aws_subnet.db.*.id
}

output "cache_subnet_ids" {
  description = "Cache subnet Ids"
  value       = aws_subnet.cache.*.id
}

output "igw_id" {
  description = "Internet Gateway Id"
  value       = aws_internet_gateway.igw.id
}

output "nat_gw_ids" {
  description = "NAT Gateway Id"
  value       = aws_nat_gateway.nat_gw.*.id
}

output "nat_gw_eips" {
  description = "Public IP addresses of the NAT Gateway"
  value       = aws_nat_gateway.nat_gw.*.public_ip
}