<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_option_group.rds_option_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_option_group) | resource |
| [aws_db_parameter_group.rds_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.rds_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_efs_file_system.efs_fs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.efs_mount_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_security_group.efs_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rds_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_nfs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.rds_master_password_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.rds_master_username_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_password.rds_master_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.rds_master_username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allocated_storage | The amount of storage of the RDS instance | `number` | `10` | no |
| app_subnet_id | The ID of the app subnet | `string` | n/a | yes |
| auto_minor_version_upgrade | Whether to allow auto minor version upgrades to the engine version | `bool` | `true` | no |
| backup_retention_period | The duration to keep an RDS snapshot | `number` | n/a | yes |
| db_subnet_ids | The subnet IDs to use for the RDS instance's subnet group | `list(string)` | n/a | yes |
| engine | The type of RDS engine | `string` | n/a | yes |
| engine_version | The version of the RDS engine | `string` | n/a | yes |
| major_engine_version | The major engine version of the RDS instance | `string` | n/a | yes |
| rds_instance_class | The instance class of the RDS instance | `string` | `"db.t3.micro"` | no |
| vpc_id | The VPC ID the resources are to be deployed in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| efs_mount_target_dns_name | The endpoint of the EFS mount target |
| efs_sg_id | The ID of the security group of EFS |
| rds_endpoint | The host endpoint of the RDS instance |
| rds_sg_id | Security group ID of the RDS instance |
| rds_subnet_group_name | Name of the RDS instance's subnet group |
<!-- END_TF_DOCS -->