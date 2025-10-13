terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      "terraform"       = "true"
      "captify:env"     = "prod"
      "captify:owner"   = "in"
      "captify:service" = "iam"
      "captify:team"    = "in"
      "captify:iac"     = "terraform"
    }
  }
}


module "aws_sso_access" {
  source = "../"

  sso_groups = [
    {
      name        = "AWS-Admins"
      description = "All Domain Administrators"
      members     = ["bofh@company.com", "pfy@company.com"]
      accounts    = ["1234567890", "0987654321"]
      permission_sets = [
        {
          name             = "AWS-ReadOnly"
          description      = "Read-only access for daily use"
          managed_policies = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
        },
        {
          name             = "AWS-Administrator"
          description      = "Break-glass administrator access"
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
          name             = "Developer-Access"
          description      = "Developer permissions"
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
}