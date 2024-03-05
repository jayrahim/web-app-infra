<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | 5.39.0 |
| random | 3.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_option_group.rds_option_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_option_group) | resource |
| [aws_db_parameter_group.rds_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.rds_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_security_group.rds_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_app_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.rds_master_password_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.rds_master_username_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_password.rds_master_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.rds_master_username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_subnets.db_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allocated_storage | The amount of storage of the RDS instance | `number` | `5` | no |
| app_cidrs | The CIDR blocks of the app subnets | `list(string)` | `[]` | no |
| auto_minor_version_upgrade | Whether to allow auto minor version upgrades to the engine version | `bool` | `true` | no |
| backup_retention_period | The duration to keep an RDS snapshot | `number` | n/a | yes |
| db_name | The name of the RDS instance | `string` | n/a | yes |
| db_subnet_ids | The subnet IDs to use for the RDS instance's subnet group | `list(string)` | n/a | yes |
| engine | The type of RDS engine (e.g. mysql) | `string` | n/a | yes |
| major_engine_version | The version of the RDS engine | `string` | n/a | yes |
| project_name | The name of the project | `string` | `"web-app-infra"` | no |
| rds_instance_class | The instance class of the RDS instance | `string` | `"db.t3.micro"` | no |
| vpc_id | The VPC ID the resources are to be deployed in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| option_group_id | The ID of the RDS option group |
| parameter_group_id | The RDS parameter group Id |
| rds_endpoint | The host endpoint of the RDS instance |
| rds_id | The ID of the RDS instance |
| rds_sg_id | Security group ID of the RDS instance |
| rds_subnet_group_name | Name of the RDS instance's subnet group |
<!-- END_TF_DOCS -->