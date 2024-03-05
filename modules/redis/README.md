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
| [aws_cloudwatch_log_group.redis_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.redis_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.redis_rep_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.redis_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_app_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_name | The project name to be used in the value of the Name tag | `string` | n/a | yes |
| redis_subnet_cidrs | The CIDRs of the cache subnets | `list(string)` | `[]` | no |
| redis_subnet_ids | The subnet IDs that comprise the Redis subnet group | `list(string)` | n/a | yes |
| replication_group_id | Name of the Redis replication group | `string` | n/a | yes |
| vpc_id | The ID of the VPC where Redis is to be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| redis_log_group_arn | The log group's ARN |
| redis_replication_group_id | The ID of the Redis replication group |
| redis_replication_group_primary_endpoint | The primary endpoint of the Redis replication group |
| redis_replication_group_reader_endpoint | The reader endpoint of the Redis replication group |
| redis_subnet_group_ids | The subnets that make up the Redis subnet group |
| security_group_id | The Redis replication group's security group Id |
<!-- END_TF_DOCS -->