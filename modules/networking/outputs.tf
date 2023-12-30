output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.web_app.id
}
output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public.*.id
}
output "web_subnet_ids" {
  description = "Web subnet IDs"
  value       = aws_subnet.web.*.id
}
output "app_subnet_ids" {
  description = "App subnet IDs"
  value       = aws_subnet.app.*.id
}
output "db_subnet_ids" {
  description = "DB subnet IDs"
  value       = aws_subnet.db.*.id
}
output "igw_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}
output "nat_gw_ids" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.nat_gw.*.id
}
output "nat_gw_eips" {
  description = "Public IP addresses of the NAT Gateway"
  value       = aws_nat_gateway.nat_gw.*.public_ip
}