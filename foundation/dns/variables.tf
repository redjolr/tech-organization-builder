terraform {
  required_providers {
    hetznerdns = {
      source  = "germanbrew/hetznerdns"
      version = "3.2.1"
    }
  }
  required_version = ">= 1.1.6"
}

variable "hetzner_dns_api_token" {
  sensitive = true
}

variable "main_domain_name" {
  type      = string
  sensitive = false
}
