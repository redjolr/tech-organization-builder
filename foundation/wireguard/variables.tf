variable "hcloud_token" {
  sensitive = true
}

variable "hetzner_dns_api_token" {
  description = "The API token that you can generate in the DNS console. It is different from the normal API token."
  type        = string
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

variable "wireguard_server_type" {
  type = string
}

variable "vpn_ddns_authentication_key_hmac_sha256" {
  type = string
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


