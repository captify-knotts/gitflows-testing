locals {
  # Sanitize permission set names (no spaces allowed)
  permission_set_names = {
    for perm_set in flatten([
      for group in var.sso_groups : [
        for ps in group.permission_sets : {
          key            = "${group.name}-${ps.name}"
          sanitized_name = replace(ps.name, " ", "-")
          description    = ps.description
        }
      ]
    ]) : perm_set.key => perm_set
  }

  # Group memberships
  group_memberships = {
    for assignment in flatten([
      for group in var.sso_groups : [
        for member in group.members : {
          key        = "${group.name}-${member}"
          group_name = group.name
          user_email = member
        }
      ]
    ]) : assignment.key => assignment
  }

  # Managed policy attachments
  managed_policy_attachments = {
    for attachment in flatten([
      for group in var.sso_groups : [
        for ps in group.permission_sets : [
          for policy in try(ps.managed_policies, []) : {
            key        = "${group.name}-${ps.name}-${policy}"
            group_name = group.name
            ps_name    = ps.name
            policy_arn = policy
          }
        ]
      ]
    ]) : attachment.key => attachment
  }

  # Customer managed policy attachments
  customer_managed_policy_attachments = {
    for attachment in flatten([
      for group in var.sso_groups : [
        for ps in group.permission_sets : [
          for cmp in try(ps.customer_managed_policies, []) : {
            key        = "${group.name}-${ps.name}-${cmp.name}-${try(cmp.path, "/")}"
            group_name = group.name
            ps_name    = ps.name
            policy     = cmp
          }
        ]
      ]
    ]) : attachment.key => attachment
  }

  # Inline policies
  inline_policies = {
    for inline in flatten([
      for group in var.sso_groups : [
        for ps in group.permission_sets : {
          key        = "${group.name}-${ps.name}"
          group_name = group.name
          ps_name    = ps.name
          policy     = ps.inline_policy
        } if try(ps.inline_policy, null) != null
      ]
    ]) : inline.key => inline
  }

  # Account assignments
  account_assignments = {
    for assignment in flatten([
      for group in var.sso_groups : [
        for ps in group.permission_sets : [
          for account in group.accounts : {
            key        = "${group.name}-${ps.name}-${account}"
            group_name = group.name
            ps_name    = ps.name
            account_id = account
          }
        ]
      ]
    ]) : assignment.key => assignment
  }
}