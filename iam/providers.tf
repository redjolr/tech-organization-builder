terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "17.4.0"
    }
    googleworkspace = {
      source  = "hashicorp/googleworkspace"
      version = "0.7.0"
    }
  }
  required_version = ">= 1.1.6"
}

provider "googleworkspace" {
  credentials             = "./secrets/admin_service_account_key.json"
  customer_id             = var.google_admin_customer_id
  impersonated_user_email = "admin@${var.main_domain_name}"
  oauth_scopes = [
    "https://www.googleapis.com/auth/admin.directory.user",
    "https://www.googleapis.com/auth/admin.directory.userschema",
  ]

}

provider "gitlab" {
  token    = var.gitlab_admin_api_personal_access_token
  base_url = "https://gitlab.internal.${var.main_domain_name}/api/v4/"
  insecure = true
}
