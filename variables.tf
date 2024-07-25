variable "aws_region" {
  description = "AWS Region where Identity Center is created"
  type        = string
}

variable "identity_store_id" {
  description = "The ID of the AWS Identity Store"
  type        = string
}

variable "users" {
  description = "List of users that should be created in the Identity Center"
  type = list(object({
    display_name  = string
    user_name     = string
    given_name    = string
    family_name   = string
    email         = string
    primary_email = bool
    email_type    = string
    groups        = list(string)
  }))
}

variable "groups" {
  description = "List of groups that should be created in the Identity Center"
  type = list(object({
    display_name = string
    description  = string
  }))
}

variable "permission_sets" {
  description = "List of permission sets that should be created in the Identity Center"
  type = list(object({
    name               = string
    description        = string
    session_duration   = string
    managed_policy_arn = string
  }))
}
