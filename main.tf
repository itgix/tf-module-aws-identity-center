data "aws_ssoadmin_instances" "identity_store" {}

# User
resource "aws_identitystore_user" "user" {
  for_each          = { for u in var.users : u.user_name => u }
  identity_store_id = tolist(data.aws_ssoadmin_instances.identity_store.identity_store_ids)[0]
  display_name      = each.value.display_name
  user_name         = each.value.user_name

  name {
    given_name  = each.value.given_name
    family_name = each.value.family_name
  }

  emails {
    value   = each.value.email
    primary = each.value.primary_email
    type    = each.value.email_type
  }
}

# Group
resource "aws_identitystore_group" "group" {
  for_each          = { for g in var.groups : g.display_name => g }
  display_name      = each.value.display_name
  description       = each.value.description
  identity_store_id = tolist(data.aws_ssoadmin_instances.identity_store.identity_store_ids)[0]
}

locals {
  user_ids  = { for u in aws_identitystore_user.user : u.user_name => u.user_id }
  group_ids = { for g in aws_identitystore_group.group : g.display_name => g.group_id }
  user_group_list = flatten([
    for user in var.users : [
      for group in user.groups : {
        user_name  = user.user_name
        group_name = group
      }
    ]
  ])
  user_group_pairs = { for ug in local.user_group_list : "${ug.user_name}-${ug.group_name}" => ug }
}


# Assign user to group
resource "aws_identitystore_group_membership" "group_association" {
  for_each = local.user_group_pairs

  identity_store_id = tolist(data.aws_ssoadmin_instances.identity_store.identity_store_ids)[0]
  group_id          = local.group_ids[each.value.group_name]
  member_id         = local.user_ids[each.value.user_name]
}


// TODO: to be tested after Identity Center is recreated with local users
# Premission set
resource "aws_ssoadmin_permission_set" "permission_set" {
  for_each     = { for p in var.permission_sets : p.name => p }
  name         = each.value.name
  description  = each.value.description
  instance_arn = tolist(data.aws_ssoadmin_instances.identity_store.arns)[0]
  # (Required, Forces new resource) The Amazon Resource Name (ARN) of the SSO Instance under which the operation will be executed.
  relay_state      = "https://s3.console.aws.amazon.com/s3/home?region=${var.aws_region}#"
  session_duration = each.value.session_duration
}

resource "aws_ssoadmin_managed_policy_attachment" "permission_set_policy" {
  for_each           = { for p in var.permission_sets : p.name => p }
  instance_arn       = tolist(data.aws_ssoadmin_instances.identity_store.arns)[0]
  managed_policy_arn = each.value.managed_policy_arn
  # TODO: how do we associate in for loop ? 
  permission_set_arn = aws_ssoadmin_permission_set.permission_set[each.key].arn
}

#resource "aws_ssoadmin_permission_set" "readonly_non_prod" {
#name             = "ReadOnlyAccess"
#description      = "A permission set with read-only access to everything except PROD"
#instance_arn     = tolist(data.aws_ssoadmin_instances.identity_store.arns)[0]
#relay_state      = "https://s3.console.aws.amazon.com/s3/home?region=${var.aws_region}#"
#session_duration = "PT2H"
#}

#resource "aws_ssoadmin_permission_set" "readonly_prod" {
#name             = "Prod-ReadOnlyAccess"
#description      = "A permission set with read-only access to PROD"
#instance_arn     = tolist(data.aws_ssoadmin_instances.identity_store.arns)[0]
#relay_state      = "https://s3.console.aws.amazon.com/s3/home?region=${var.aws_region}#"
#session_duration = "PT1H"
#}
