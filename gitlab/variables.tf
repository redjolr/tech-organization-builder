variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "hetzner_dns_api_token" {
  description = "The API token that you can generate in the DNS console. It is different from the normal API token."
  type        = string
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

variable "main_domain_name" {
  type = string
}

variable "main_dns_zone_id" {
  type = string
}

variable "internal_tools_network_id" {
  type = string
}

variable "internal_tools_subnet" {
  type = any
}

variable "smtp_username" {
  type = string
}

variable "smtp_password" {
  type      = string
  sensitive = true
}

variable "smtp_server_address" {
  type = string
}

variable "gitlab_root_password" {
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

variable "gitlab_ipv4_address_in_vpn_network" {
  type = string
}

variable "gitlab_ipv4_address_in_internal_tools_network" {
  type = string
}

variable "vpn_ddns_authentication_key_hmac_sha256" {
  type = string
}

variable "wireguard_vpn_peer_public_key" {
  type = string
}

variable "wireguard_ssh_admin_private_key" {
  type = string
}

variable "vpn_server_ipv4_address_in_internal_tools_network" {
  type = string
}

variable "vpn_server_ipv4_address_in_vpn_network" {
  type = string
}

variable "gitlab_server_type" {
  type = string
}
