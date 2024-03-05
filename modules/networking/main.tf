locals {
  az_names             = data.aws_availability_zones.azs.names
  default_public_cidrs = toset(["10.0.0.0/20", "10.0.16.0/20"])
  default_web_cidrs    = toset(["10.0.32.0/20", "10.0.48.0/20"])
  default_app_cidrs    = toset(["10.0.64.0/20", "10.0.80.0/20"])
  default_db_cidrs     = toset(["10.0.96.0/20", "10.0.112.0/20"])
  default_cache_cidrs  = toset(["10.0.128.0/20", "10.0.144.0/20"])
  route_table_names    = ["public", "private"]
  gateways             = [aws_internet_gateway.igw.id, aws_nat_gateway.nat_gw.0.id]
}

resource "aws_vpc" "web_app" {
  cidr_block                           = var.vpc_cidr
  enable_dns_support                   = var.enable_dns_support
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.web_app.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_eip" "nat_gw_ip" {
  count  = length(var.public_cidrs) > 0 ? length(var.public_cidrs) : length(local.default_public_cidrs)
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-eip-${count.index}"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_cidrs) > 0 ? length(var.public_cidrs) : length(local.default_public_cidrs)
  vpc_id            = aws_vpc.web_app.id
  availability_zone = local.az_names[count.index]
  cidr_block        = length(var.public_cidrs) > 0 ? tolist(var.public_cidrs)[count.index] : tolist(local.default_public_cidrs)[count.index]
  tags = {
    Name = "${var.project_name}-pub-sub-${local.az_names[count.index]}"
  }
}

resource "aws_subnet" "web" {
  count             = length(var.web_cidrs) > 0 ? length(var.web_cidrs) : length(local.default_web_cidrs)
  vpc_id            = aws_vpc.web_app.id
  availability_zone = local.az_names[count.index]
  cidr_block        = length(var.web_cidrs) > 0 ? tolist(var.web_cidrs)[count.index] : tolist(local.default_web_cidrs)[count.index]
  tags = {
    Name = "${var.project_name}-web-sub-${local.az_names[count.index]}"
  }
}

resource "aws_subnet" "app" {
  count             = length(var.app_cidrs) > 0 ? length(var.app_cidrs) : length(local.default_app_cidrs)
  vpc_id            = aws_vpc.web_app.id
  availability_zone = local.az_names[count.index]
  cidr_block        = length(var.app_cidrs) > 0 ? tolist(var.app_cidrs)[count.index] : tolist(local.default_app_cidrs)[count.index]
  tags = {
    Name = "${var.project_name}-app-sub-${local.az_names[count.index]}"
  }
}

resource "aws_subnet" "db" {
  count             = length(var.db_cidrs) > 0 ? length(var.db_cidrs) : length(local.default_db_cidrs)
  vpc_id            = aws_vpc.web_app.id
  availability_zone = local.az_names[count.index]
  cidr_block        = length(var.db_cidrs) > 0 ? tolist(var.db_cidrs)[count.index] : tolist(local.default_db_cidrs)[count.index]
  tags = {
    Name = "${var.project_name}-db-sub-${local.az_names[count.index]}"
  }
}

resource "aws_subnet" "cache" {
  count             = length(var.cache_cidrs) > 0 ? length(var.cache_cidrs) : length(local.default_cache_cidrs)
  vpc_id            = aws_vpc.web_app.id
  availability_zone = local.az_names[count.index]
  cidr_block        = length(var.cache_cidrs) > 0 ? tolist(var.cache_cidrs)[count.index] : tolist(local.default_cache_cidrs)[count.index]
  tags = {
    Name = "${var.project_name}-cache-sub-${local.az_names[count.index]}"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count             = length(var.app_cidrs) > 0 ? length(var.app_cidrs) : length(local.default_app_cidrs)
  depends_on        = [aws_internet_gateway.igw]
  connectivity_type = "public"
  allocation_id     = aws_eip.nat_gw_ip.*.id[count.index]
  subnet_id         = aws_subnet.public.*.id[count.index]
  tags = {
    Name = "${var.project_name}-nat-gw-${count.index}"
  }
}

resource "aws_route_table" "route_tables" {
  count  = length(local.route_table_names)
  vpc_id = aws_vpc.web_app.id
  tags = {
    Name = "${var.project_name}-${local.route_table_names[count.index]}-rtb"
  }
}

resource "aws_route" "default_routes" {
  count                  = length(local.route_table_names)
  route_table_id         = aws_route_table.route_tables[count.index].id
  depends_on             = [aws_route_table.route_tables]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = local.gateways[count.index]
}

resource "aws_route_table_association" "public_rtb_public_subnets" {
  count          = length(local.route_table_names)
  route_table_id = aws_route_table.route_tables[count.index].id
  subnet_id      = aws_subnet.public[count.index].id
}


resource "aws_route_table_association" "public_rtb_web_subnets" {
  count          = length(local.route_table_names)
  route_table_id = aws_route_table.route_tables[count.index].id
  subnet_id      = aws_subnet.web[count.index].id
}


resource "aws_route_table_association" "private_rtb_app_subnets" {
  count          = length(local.route_table_names)
  route_table_id = aws_route_table.route_tables[count.index].id
  subnet_id      = aws_subnet.app[count.index].id
}

resource "aws_route_table_association" "private_rtb_db_subnets" {
  count          = length(local.route_table_names)
  route_table_id = aws_route_table.route_tables[count.index].id
  subnet_id      = aws_subnet.db[count.index].id
}

resource "aws_route_table_association" "private_rtb_cache_subnets" {
  count          = length(local.route_table_names)
  route_table_id = aws_route_table.route_tables[count.index].id
  subnet_id      = aws_subnet.cache[count.index].id
}