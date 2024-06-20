data "aws_ssoadmin_instances" "identity_store" {}

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

resource "aws_identitystore_group_membership" "group_association" {
  for_each = local.user_group_pairs

  identity_store_id = tolist(data.aws_ssoadmin_instances.identity_store.identity_store_ids)[0]
  group_id          = local.group_ids[each.value.group_name]
  member_id         = local.user_ids[each.value.user_name]
}

