

module "internal_mail_server" {
  source           = "./internal_mail_server"
  main_domain_name = var.main_domain_name
  main_dns_zone_id = module.dns.main_dns_zone.id

  aws_account_region    = var.aws_account_region
  aws_access_key        = var.aws_access_key
  aws_secret_key        = var.aws_secret_key
  hetzner_dns_api_token = var.hetzner_dns_api_token
}

module "wireguard" {
  source                                            = "./wireguard"
  hcloud_token                                      = var.hcloud_token
  hetzner_dns_api_token                             = var.hetzner_dns_api_token
  vpn_ddns_authentication_key_hmac_sha256           = var.vpn_ddns_authentication_key_hmac_sha256
  main_domain_name                                  = var.main_domain_name
  main_dns_zone_id                                  = module.dns.main_dns_zone.id
  internal_tools_network_id                         = module.network.internal_tools_network.id
  internal_tools_subnet                             = module.network.internal_tools_subnet
  wireguard_server_type                             = var.wireguard_server_type
  vpn_server_ipv4_address_in_internal_tools_network = var.vpn_server_ipv4_address_in_internal_tools_network
  vpn_server_ipv4_address_in_vpn_network            = var.vpn_server_ipv4_address_in_vpn_network
  first_vpn_user_ipv4_address_in_vpn_network        = var.first_vpn_user_ipv4_address_in_vpn_network
}

module "dns" {
  source                = "./dns"
  hetzner_dns_api_token = var.hetzner_dns_api_token
  main_domain_name      = var.main_domain_name
}

module "network" {
  source = "./network"
}
