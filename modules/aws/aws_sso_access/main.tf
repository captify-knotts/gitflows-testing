resource "aws_identitystore_group" "this" {
  for_each = { for group in var.sso_groups : group.name => group }

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  display_name      = each.value.name
  description       = each.value.description
}

resource "aws_identitystore_group_membership" "this" {
  for_each = local.group_memberships

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = aws_identitystore_group.this[each.value.group_name].group_id
  member_id         = data.aws_identitystore_user.this[each.value.user_email].user_id
}

resource "aws_ssoadmin_permission_set" "this" {
  for_each = local.permission_set_names

  name             = each.value.sanitized_name
  description      = each.value.description
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  session_duration = var.session_duration
}

resource "aws_ssoadmin_account_assignment" "this" {
  for_each = local.account_assignments

  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.this["${each.value.group_name}-${each.value.ps_name}"].arn
  principal_id       = aws_identitystore_group.this[each.value.group_name].group_id
  principal_type     = "GROUP"

  target_id   = each.value.account_id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = local.managed_policy_attachments

  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.this["${each.value.group_name}-${each.value.ps_name}"].arn
  managed_policy_arn = each.value.policy_arn

  depends_on = [aws_ssoadmin_account_assignment.this]
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "this" {
  for_each = local.customer_managed_policy_attachments

  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.this["${each.value.group_name}-${each.value.ps_name}"].arn

  customer_managed_policy_reference {
    name = each.value.policy.name
    path = try(each.value.policy.path, "/")
  }

  depends_on = [aws_ssoadmin_account_assignment.this]
}

resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  for_each = local.inline_policies

  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.this["${each.value.group_name}-${each.value.ps_name}"].arn
  inline_policy      = each.value.policy

  depends_on = [aws_ssoadmin_account_assignment.this]
}
# comment
