variable "hcloud_token" {
  description = "The API token that you need to generate in your Hetzner account"
  sensitive   = true
}

variable "hetzner_dns_api_token" {
  description = "The API token that you can generate in the DNS console. It is different from the normal API token."
  sensitive   = true
}

variable "main_domain_name" {
  type = string
}

variable "gitlab_self_signed_cert_country" {
  type = string
}

variable "gitlab_self_signed_cert_common_name" {
  type = string
}

variable "gitlab_self_signed_cert_organization" {
  type = string
}

variable "aws_account_region" {
  type = string
}


variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "gitlab_admin_email" {
  type = string
}

variable "gitlab_admin_password" {
  type      = string
  sensitive = true
}

variable "gitlab_root_password" {
  type      = string
  sensitive = true
}

variable "gitlab_admin_username" {
  type = string
}

variable "google_oauth_app_id" {
  type = string
}

variable "google_oauth_app_secret" {
  type      = string
  sensitive = true
}

variable "wireguard_server_type" {
  type = string
}

variable "vpn_ddns_authentication_key_hmac_sha256" {
  type      = string
  sensitive = true
}

variable "vpn_server_ipv4_address_in_internal_tools_network" {
  type = string
}

variable "vpn_server_ipv4_address_in_vpn_network" {
  type = string
}

variable "first_vpn_user_ipv4_address_in_vpn_network" {
  type = string
}
