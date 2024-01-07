locals {
  az_names             = data.aws_availability_zones.azs.names
  default_public_cidrs = toset(["10.1.0.0/24", "10.1.1.0/24"])
  default_web_cidrs    = toset(["10.1.2.0/24", "10.1.3.0/24"])
  default_app_cidrs    = toset(["10.1.4.0/24", "10.1.5.0/24"])
  default_db_cidrs     = toset(["10.1.6.0/24", "10.1.7.0/24"])
  route_tables         = ["pub", "priv"]

}

resource "aws_vpc" "web_app" {
  cidr_block                           = var.vpc_cidr
  enable_dns_support                   = var.enable_dns_support
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics

  tags = {
    Name = "web-app-infra-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.web_app.id

  tags = {
    Name = "web-app-infra-igw"
  }
}

resource "aws_eip" "nat_gw_ip" {
  count  = length(var.public_cidrs) > 0 ? length(var.public_cidrs) : length(local.default_public_cidrs)
  domain = "vpc"

  tags = {
    Name = "web-app-infra-eip-${count.index}"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_cidrs) > 0 ? length(var.public_cidrs) : length(local.default_public_cidrs)
  vpc_id            = aws_vpc.web_app.id
  availability_zone = local.az_names[count.index]
  cidr_block        = length(var.public_cidrs) > 0 ? tolist(var.public_cidrs)[count.index] : tolist(local.default_public_cidrs)[count.index]

  tags = {
    Name = "web-app-infra-pub-sub-${local.az_names[count.index]}"
  }
}

resource "aws_subnet" "web" {
  count             = length(var.web_cidrs) > 0 ? length(var.web_cidrs) : length(local.default_web_cidrs)
  vpc_id            = aws_vpc.web_app.id
  availability_zone = local.az_names[count.index]
  cidr_block        = length(var.web_cidrs) > 0 ? tolist(var.web_cidrs)[count.index] : tolist(local.default_web_cidrs)[count.index]

  tags = {
    Name = "web-app-infra-web-sub-${local.az_names[count.index]}"
  }
}

resource "aws_subnet" "app" {
  count             = length(var.app_cidrs) > 0 ? length(var.app_cidrs) : length(local.default_app_cidrs)
  vpc_id            = aws_vpc.web_app.id
  availability_zone = local.az_names[count.index]
  cidr_block        = length(var.app_cidrs) > 0 ? tolist(var.app_cidrs)[count.index] : tolist(local.default_app_cidrs)[count.index]

  tags = {
    Name = "web-app-infra-app-sub-${local.az_names[count.index]}"
  }
}

resource "aws_subnet" "db" {
  count             = length(var.db_cidrs) > 0 ? length(var.db_cidrs) : length(local.default_db_cidrs)
  vpc_id            = aws_vpc.web_app.id
  availability_zone = local.az_names[count.index]
  cidr_block        = length(var.app_cidrs) > 0 ? tolist(var.db_cidrs)[count.index] : tolist(local.default_db_cidrs)[count.index]

  tags = {
    Name = "web-app-infra-db-sub-${local.az_names[count.index]}"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count             = length(var.app_cidrs) > 0 ? length(var.app_cidrs) : length(local.default_app_cidrs)
  depends_on        = [aws_internet_gateway.igw]
  connectivity_type = "public"
  allocation_id     = aws_eip.nat_gw_ip.*.id[count.index]
  subnet_id         = aws_subnet.public.*.id[count.index]

  tags = {
    Name = "web-app-infra-nat-gw-${count.index}"
  }
}

resource "aws_route_table" "route_tables" {
  count  = length(local.route_tables)
  vpc_id = aws_vpc.web_app.id
  
  tags = {
    Name = "web-app-infra-${local.route_tables[count.index]}-rt"
  }
}

resource "aws_route" "public_rt_default_route" {
  route_table_id         = aws_route_table.route_tables.0.id
  depends_on             = [aws_route_table.route_tables]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "private_rt_default_route" {
  route_table_id         = aws_route_table.route_tables.1.id
  depends_on             = [aws_route_table.route_tables]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gw.0.id
}

resource "aws_route_table_association" "public_rt_public_subnet_0" {
  route_table_id = aws_route_table.route_tables.0.id
  subnet_id      = aws_subnet.public.0.id
}

resource "aws_route_table_association" "public_rt_public_subnet_1" {
  route_table_id = aws_route_table.route_tables.0.id
  subnet_id      = aws_subnet.public.1.id
}

resource "aws_route_table_association" "public_rt_web_subnet_0" {
  route_table_id = aws_route_table.route_tables.0.id
  subnet_id      = aws_subnet.web.0.id
}

resource "aws_route_table_association" "public_rt_web_subnet_1" {
  route_table_id = aws_route_table.route_tables.0.id
  subnet_id      = aws_subnet.web.1.id
}
resource "aws_route_table_association" "private_rt_app_subnet_0" {
  route_table_id = aws_route_table.route_tables.1.id
  subnet_id      = aws_subnet.app.0.id
}

resource "aws_route_table_association" "private_rt_app_subnet_1" {
  route_table_id = aws_route_table.route_tables.1.id
  subnet_id      = aws_subnet.app.1.id
}