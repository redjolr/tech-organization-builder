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
    smtp = {
      source  = "venkadeshwarank/smtp"
      version = "0.3.1"
    }
    wireguard = {
      source  = "OJFord/wireguard"
      version = "0.3.1"
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

provider "smtp" {
  authentication = true
  host           = var.internal_smtp_server_address
  port           = var.internal_smtp_server_port
  username       = var.internal_smtp_username
  password       = var.internal_smtp_password
}
