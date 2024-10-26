terraform {
  required_providers {

    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "17.4.0"
    }
  }
  required_version = ">= 1.1.6"
}


provider "gitlab" {
  token    = var.gitlab_admin_api_personal_access_token
  base_url = "https://gitlab.internal.${var.main_domain_name}/api/v4/"
  insecure = true
}
