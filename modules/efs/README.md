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
| [aws_efs_file_system.efs_fs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.efs_mount_targets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_security_group.efs_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_nfs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app_subnet_ids | The app subnet Ids | `list(string)` | `[]` | no |
| project_name | The name of the project | `string` | `"web-app-infra"` | no |
| vpc_id | The ID of the VPC where EFS will be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| efs_arn | The ARN of the EFS |
| efs_arns_asssociated_with_mount_targets | The ARNs associated with each of the mount targets (should be the same ARN for both) |
| efs_mount_target_dns_names | The endpoints of the EFS mount targets |
| efs_sg_id | The ID of the security group of EFS |
<!-- END_TF_DOCS -->