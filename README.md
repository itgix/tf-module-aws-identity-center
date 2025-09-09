The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_identitystore_group.group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group) | resource |
| [aws_identitystore_group_membership.group_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group_membership) | resource |
| [aws_identitystore_user.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_user) | resource |
| [aws_ssoadmin_account_assignment.account_assignment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_managed_policy_attachment.permission_set_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_managed_policy_attachment) | resource |
| [aws_ssoadmin_permission_set.permission_set](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set) | resource |
| [aws_ssoadmin_instances.identity_store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region where Identity Center is created | `string` | n/a | yes |
| <a name="input_groups"></a> [groups](#input\_groups) | List of groups that should be created in the Identity Center | <pre>list(object({<br/>    display_name = string<br/>    description  = string<br/>    accounts = list(object({<br/>      account_id     = string<br/>      permission_set = string<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_identity_store_id"></a> [identity\_store\_id](#input\_identity\_store\_id) | The ID of the AWS Identity Store | `string` | n/a | yes |
| <a name="input_permission_sets"></a> [permission\_sets](#input\_permission\_sets) | List of permission sets that should be created in the Identity Center | <pre>list(object({<br/>    name               = string<br/>    description        = string<br/>    session_duration   = string<br/>    managed_policy_arn = string<br/>  }))</pre> | n/a | yes |
| <a name="input_users"></a> [users](#input\_users) | List of users that should be created in the Identity Center | <pre>list(object({<br/>    display_name  = string<br/>    user_name     = string<br/>    given_name    = string<br/>    family_name   = string<br/>    email         = string<br/>    primary_email = bool<br/>    email_type    = string<br/>    groups        = list(string)<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
