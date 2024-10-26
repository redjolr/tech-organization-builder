terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    hetznerdns = {
      source  = "germanbrew/hetznerdns"
      version = "3.2.1"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "17.4.0"
    }
  }
  required_version = ">= 1.1.6"
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "hetznerdns" {
  api_token = var.hetzner_dns_api_token
}


provider "gitlab" {
  token    = var.gitlab_admin_api_personal_access_token
  base_url = "https://gitlab.internal.${var.main_domain_name}/api/v4/"
  insecure = true
}
