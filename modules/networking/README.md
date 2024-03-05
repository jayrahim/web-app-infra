<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | 5.39.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat_gw_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat_gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.default_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.route_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_rtb_app_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private_rtb_cache_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private_rtb_db_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_rtb_public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_rtb_web_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.cache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.web_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.azs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app_cidrs | The set of CIDRs for the public subnets | `set(string)` | `[]` | no |
| cache_cidrs | The set of CIDRs for the cache subnets | `set(string)` | `[]` | no |
| db_cidrs | The set of CIDRs for the public subnets | `set(string)` | `[]` | no |
| enable_dns_hostnames | Whether to enable DNS hostnames | `bool` | `false` | no |
| enable_dns_support | Whether to enable DNS support | `bool` | `true` | no |
| enable_network_address_usage_metrics | Whether to enable NAU metrics | `bool` | `false` | no |
| project_name | The name of the project | `string` | `"web-app-infra"` | no |
| public_cidrs | The set of CIDRs for the public subnets | `set(string)` | `[]` | no |
| vpc_cidr | The CIDR block of the VPC. If you overwrite the default value, you must also provide values for the subnet CIDRs, i.e., public_cidrs etc. | `string` | `"10.0.0.0/16"` | no |
| web_cidrs | The set of CIDRs for the public subnets | `set(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| app_subnet_ids | App subnet Ids |
| cache_subnet_ids | Cache subnet Ids |
| db_subnet_ids | DB subnet Ids |
| default_route_states | The state of the default routes |
| igw_id | Internet Gateway Id |
| nat_gw_eips | Public IP addresses of the NAT Gateway |
| nat_gw_ids | NAT Gateway Id |
| private_rtb_app_subnets_association_id | The association Id for the private route table and the app subnets |
| private_rtb_cache_association_id | The association Id for the private route table and the cache subnets |
| private_rtb_db_subnets_association_id | The association Id for the private route table and the db subnets |
| public_rtb_public_subnets_association_id | The association Id for the public route table and the public subnets |
| public_rtb_web_subnets_association_id | The association Id for the public route table and the web subnets |
| public_subnet_ids | Public subnet Ids |
| route_table_ids | The route table Ids |
| vpc_id | The VPC Id |
| web_subnet_ids | Web subnet Ids |
<!-- END_TF_DOCS -->