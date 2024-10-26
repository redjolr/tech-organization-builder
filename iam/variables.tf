variable "gitlab_admin_api_personal_access_token" {
  type      = string
  sensitive = true
}

variable "main_domain_name" {
  type = string
}

variable "google_admin_customer_id" {
  type      = string
  sensitive = false
}

variable "internal_smtp_username" {
  type = string
}

variable "internal_smtp_password" {
  type      = string
  sensitive = true
}

variable "internal_smtp_server_address" {
  type = string
}

variable "internal_smtp_server_port" {
  type = number
}

variable "wireguard_vpn_peer_public_key" {
  type = string
}

variable "vpn_server_ipv4_address_in_vpn_network" {
  type = string
}
