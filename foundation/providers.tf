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
  }
  required_version = ">= 1.1.6"
}

provider "hetznerdns" {
  api_token = var.hetzner_dns_api_token
}
