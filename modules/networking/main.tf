locals {
  az_names          = data.aws_availability_zones.azs.names
  default_pub_cidrs = toset(["10.1.0.0/24", "10.1.1.0/24"])
  default_web_cidrs = toset(["10.1.2.0/24", "10.1.3.0/24"])
  default_app_cidrs = toset(["10.1.4.0/24", "10.1.5.0/24"])
  default_db_cidrs  = toset(["10.1.6.0/24", "10.1.7.0/24"])

}

resource "aws_vpc" "web_app" {
  cidr_block                           = var.vpc_cidr
  enable_dns_support                   = var.enable_dns_support
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.web_app.id
}

resource "aws_eip" "nat_gw_ip" {
  count      = length(var.public_cidrs) > 0 ? length(var.public_cidrs) : length(local.default_pub_cidrs)
  depends_on = [aws_internet_gateway.igw]
  domain     = "vpc"
}

resource "aws_subnet" "public" {
  count             = length(var.public_cidrs) > 0 ? length(var.public_cidrs) : length(local.default_pub_cidrs)
  vpc_id            = aws_vpc.web_app.id
  availability_zone = local.az_names[count.index]
  cidr_block        = length(var.public_cidrs) > 0 ? tolist(var.public_cidrs)[count.index] : tolist(local.default_pub_cidrs)[count.index]
}

resource "aws_subnet" "web" {
  count             = length(var.web_cidrs) > 0 ? length(var.web_cidrs) : length(local.default_web_cidrs)
  vpc_id            = aws_vpc.web_app.id
  availability_zone = local.az_names[count.index]
  cidr_block        = length(var.web_cidrs) > 0 ? tolist(var.web_cidrs)[count.index] : tolist(local.default_web_cidrs)[count.index]
}

resource "aws_subnet" "app" {
  count             = length(var.app_cidrs) > 0 ? length(var.app_cidrs) : length(local.default_app_cidrs)
  vpc_id            = aws_vpc.web_app.id
  availability_zone = local.az_names[count.index]
  cidr_block        = length(var.app_cidrs) > 0 ? tolist(var.app_cidrs)[count.index] : tolist(local.default_app_cidrs)[count.index]
}

resource "aws_subnet" "db" {
  count             = length(var.db_cidrs) > 0 ? length(var.db_cidrs) : length(local.default_db_cidrs)
  vpc_id            = aws_vpc.web_app.id
  availability_zone = local.az_names[count.index]
  cidr_block        = length(var.app_cidrs) > 0 ? tolist(var.db_cidrs)[count.index] : tolist(local.default_db_cidrs)[count.index]
}

resource "aws_nat_gateway" "nat_gw" {
  count             = length(var.app_cidrs) > 0 ? length(var.app_cidrs) : length(local.default_app_cidrs)
  depends_on        = [aws_internet_gateway.igw]
  connectivity_type = "public"
  allocation_id     = aws_eip.nat_gw_ip.*.id[count.index]
  subnet_id         = aws_subnet.public.*.id[count.index]
}