module "users" {
  source                                 = "./users"
  main_domain_name                       = var.main_domain_name
  google_admin_customer_id               = var.google_admin_customer_id
  gitlab_admin_api_personal_access_token = var.gitlab_admin_api_personal_access_token
  wireguard_vpn_peer_public_key          = var.wireguard_vpn_peer_public_key
  internal_smtp_username                 = var.internal_smtp_username
  internal_smtp_password                 = var.internal_smtp_password
  internal_smtp_server_address           = var.internal_smtp_server_address
  internal_smtp_server_port              = var.internal_smtp_server_port
  vpn_server_ipv4_address_in_vpn_network = var.vpn_server_ipv4_address_in_vpn_network
}
