variable "sso_groups" {
  description = "AWS IAM Identity Centre Groups for Google Synced Users"
  type = list(object({
    name        = string
    description = optional(string)
    members     = list(string) # User emails from Google Workspace
    accounts    = list(string) # Target AWS account IDs
    permission_sets = list(object({
      name             = string
      description      = optional(string)
      managed_policies = optional(list(string), [])
      customer_managed_policies = optional(list(object({
        name = string
        path = optional(string, "/")
      })), [])
      inline_policy = optional(string)
    }))
  }))
  default = []
}

variable "session_duration" {
  description = "SSO session duration"
  type        = string
  default     = "PT1H"
}