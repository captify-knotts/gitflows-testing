# AWS SSO ACCESS

Terraform module to create AWS IAM Identity Center (SSO) Groups, Permission Sets and Account Assignments. 

## Prerequisites
1. AWS Organization with accounts already created
2. IAM Identity Center enabled in management account 
3. Google Workspace configured as identity provider (SCIM)

## Usage

Edit `terraform.tfvars`:

```hcl
# Session duration for SSO (ISO 8601 format)
session_duration = "PT2H"  # 2 hours

# Define your SSO groups
sso_groups = [
  {
    name        = "AWS-Admins"
    description = "All Domain Administrators"
    members     = ["bofh@company.com", "pfy@company.com"]
    accounts    = ["1234567890", "0987654321"]
    permission_sets = [
      {
        name        = "AWS-ReadOnly"
        description = "Read-only access for daily use"
        managed_policies = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
      },
      {
        name        = "AWS-Administrator"
        description = "Break-glass administrator access"
        managed_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      }
    ]
  },

  {
    name        = "AWS-Developers"
    description = "Developer team access"
    members     = ["alice@company.com", "bob@company.com"]
    accounts    = ["1234567890"]
    permission_sets = [
      {
        name        = "Developer-Access"
        description = "Developer permissions"
        managed_policies = ["arn:aws:iam::aws:policy/PowerUserAccess"]
      }
    ]
  },

  {
    name        = "S3 Operators"
    description = "S3 buckets all access"
    members     = ["jack@company.com", "jill@company.com"]
    accounts    = ["1234567890"]
    customer_managed_policies = [
        {
            name = "MyCustomPolicy"
            path = "/"
        }
    ]
    inline_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
              Effect = "Allow"
              Action = [
                "s3:GetObject",
                "s3:ListBucket"
              ]
              Resource = "*"
            }
          ]
        })
    }
]
```
### SSO Group Structure
```hcl
{
  name        = string                  # Group display name
  description = string                  # Group description (optional)
  members     = list(string)            # List of user emails from Google Workspace
  accounts    = list(string)            # Target AWS account IDs
  permission_sets = list(object({       # Permission sets for this group
    name        = string                # Permission set name (no spaces!)
    description = string                # Permission set description
    managed_policies = optional(list(string), [])                    # AWS managed policy ARNs
    customer_managed_policies = optional(list(object({               # Customer managed policies
      name = string
      path = optional(string, "/")
    })), [])
    inline_policy = optional(string)    # JSON inline policy
  }))
}
```

### Policy Types
AWS Managed Policies
```hcl
managed_policies = [
  "arn:aws:iam::aws:policy/AdministratorAccess",
  "arn:aws:iam::aws:policy/ReadOnlyAccess"
]
```

Customer Managed Policies
```hcl
customer_managed_policies = [
  {
    name = "MyCustomPolicy"
    path = "/"  # optional, defaults to "/"
  }
]
```

Inline Policies
```hcl
inline_policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Effect   = "Allow"
      Action   = ["s3:GetObject", "s3:ListBucket"]
      Resource = "*"
    }
  ]
})
```

## Troubleshooting
### Common Issues
1. "User not found" errors
- Ensure users are synced from Google Workspace first
- Verify email addresses match exactly

2. Permission set name validation errors
- Remove spaces from permission set names
- Use hyphens instead of spaces

3. Account assignment failures
- Verify account IDs are correct
- Ensure you're running Terraform in the <strong>organization management</strong> account



## Maintenance
### Adding New Groups
1. Add new group configuration to sso_groups in `terraform.tfvars`
2. Run `terraform plan` and `terraform apply`

### Modifying Existing Groups
1. Update the group configuration in `terraform.tfvars`
2. Terraform will detect changes and update resources accordingly

### Removing Groups
1. Remove the group from sso_groups in `terraform.tfvars`
2. Run `terraform apply` - Terraform will remove the group and all associated resources

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
| [aws_identitystore_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group) | resource |
| [aws_identitystore_group_membership.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group_membership) | resource |
| [aws_ssoadmin_account_assignment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_customer_managed_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_customer_managed_policy_attachment) | resource |
| [aws_ssoadmin_managed_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_managed_policy_attachment) | resource |
| [aws_ssoadmin_permission_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set) | resource |
| [aws_ssoadmin_permission_set_inline_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set_inline_policy) | resource |
| [aws_identitystore_user.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_user) | data source |
| [aws_ssoadmin_instances.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_session_duration"></a> [session\_duration](#input\_session\_duration) | SSO session duration | `string` | `"PT1H"` | no |
| <a name="input_sso_groups"></a> [sso\_groups](#input\_sso\_groups) | AWS IAM Identity Centre Groups for Google Synced Users | <pre>list(object({<br/>    name        = string<br/>    description = optional(string)<br/>    members     = list(string) # User emails from Google Workspace<br/>    accounts    = list(string) # Target AWS account IDs<br/>    permission_sets = list(object({<br/>      name             = string<br/>      description      = optional(string)<br/>managed_policies = optional(list(string), [])<br/>      customer_managed_policies = optional(list(object({<br/>        name = string<br/>        path = optional(string, "/")<br/>      })), [])<br/>      inline_policy = optional(string)<br/>    }))<br/>  }))</pre> | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->