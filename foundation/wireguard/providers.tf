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
    dynamic-dns = {
      source  = "hashicorp/dns"
      version = "3.4.2"
    }
    wireguard = {
      source  = "OJFord/wireguard"
      version = "0.3.1"
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

provider "wireguard" {
}

provider "dynamic-dns" {
  update {
    server        = "wireguard.internal.${var.main_domain_name}"
    key_name      = "ddns_key."
    key_algorithm = "hmac-sha256"
    key_secret    = var.vpn_ddns_authentication_key_hmac_sha256
  }
}
