variable "main_domain_name" {
  type = string
}

variable "gitlab_admin_api_personal_access_token" {
  type      = string
  sensitive = true
}
