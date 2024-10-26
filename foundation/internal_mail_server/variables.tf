#provider.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.47.0"
    }
    hetznerdns = {
      source  = "germanbrew/hetznerdns"
      version = "3.2.1"
    }
  }
}

variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "hetzner_dns_api_token" {
  type      = string
  sensitive = true
}

variable "aws_account_region" {
  type = string
}

variable "main_domain_name" {
  type = string
}

variable "main_dns_zone_id" {
  type = string
}



