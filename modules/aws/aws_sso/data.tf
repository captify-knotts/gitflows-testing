data "aws_ssoadmin_instances" "this" {}

data "aws_identitystore_user" "this" {
  for_each = toset(flatten([
    for group in var.sso_groups : [
      for member in group.members : member
    ]
  ]))

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = each.key
    }
  }
}


# minor change