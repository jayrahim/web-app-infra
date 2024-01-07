<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat_gw_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat_gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private_rt_default_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_rt_default_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.route_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_rt_app_subnet_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private_rt_app_subnet_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private_rt_db_subnet_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private_rt_db_subnet_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_rt_public_subnet_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_rt_public_subnet_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_rt_web_subnet_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_rt_web_subnet_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.web_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.azs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app_cidrs | The set of CIDRs for the public subnets | `set(string)` | `[]` | no |
| db_cidrs | The set of CIDRs for the public subnets | `set(string)` | `[]` | no |
| enable_dns_hostnames | Whether to enable DNS hostnames | `bool` | `false` | no |
| enable_dns_support | Whether to enable DNS support | `bool` | `true` | no |
| enable_network_address_usage_metrics | Whether to enable NAU metrics | `bool` | `false` | no |
| public_cidrs | The set of CIDRs for the public subnets | `set(string)` | `[]` | no |
| vpc_cidr | The CIDR block of the VPC. If you overwrite the default value, you must also provide values for the subnet CIDRs, i.e., public_cidrs etc. | `string` | `"10.0.0.0/16"` | no |
| web_cidrs | The set of CIDRs for the public subnets | `set(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| app_subnet_ids | App subnet IDs |
| db_subnet_ids | DB subnet IDs |
| igw_id | Internet Gateway ID |
| nat_gw_eips | Public IP addresses of the NAT Gateway |
| nat_gw_ids | NAT Gateway ID |
| public_subnet_ids | Public subnet IDs |
| vpc_id | The VPC ID |
| web_subnet_ids | Web subnet IDs |
<!-- END_TF_DOCS -->