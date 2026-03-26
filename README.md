The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/

# AWS Identity Center Terraform Module

This module manages AWS IAM Identity Center (SSO) users, groups, permission sets, and account assignments.

Part of the [ITGix AWS Landing Zone](https://itgix.com/itgix-landing-zone/).

## Resources Created

- Identity Center users
- Identity Center groups with membership
- Permission sets with managed policy attachments
- Account assignments (group-to-account with permission set)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `aws_region` | AWS Region where Identity Center is created | `string` | — | yes |
| `identity_store_id` | The ID of the AWS Identity Store | `string` | — | yes |
| `users` | List of users to create in Identity Center | `list(object({display_name, user_name, given_name, family_name, email, primary_email, email_type, groups}))` | — | yes |
| `groups` | List of groups to create with account assignments | `list(object({display_name, description, accounts=list(object({account_id, permission_set}))}))` | — | yes |
| `permission_sets` | List of permission sets to create | `list(object({name, description, session_duration, managed_policy_arn}))` | — | yes |

## Usage Example

```hcl
module "identity_center" {
  source = "path/to/tf-module-aws-identity-center"

  aws_region       = "eu-central-1"
  identity_store_id = "d-1234567890"

  permission_sets = [
    {
      name               = "AdministratorAccess"
      description        = "Full admin access"
      session_duration   = "PT8H"
      managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
    }
  ]

  groups = [
    {
      display_name = "Admins"
      description  = "Administrator group"
      accounts = [
        {
          account_id     = "123456789012"
          permission_set = "AdministratorAccess"
        }
      ]
    }
  ]

  users = [
    {
      display_name  = "John Doe"
      user_name     = "john.doe"
      given_name    = "John"
      family_name   = "Doe"
      email         = "john.doe@example.com"
      primary_email = true
      email_type    = "work"
      groups        = ["Admins"]
    }
  ]
}
```
