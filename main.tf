module "backend_terraform" {
  source             = "./backend_terraform"
  main_domain_name   = var.main_domain_name
  aws_secret_key     = var.aws_secret_key
  aws_account_region = var.aws_account_region
  aws_access_key     = var.aws_access_key
}

module "foundation" {
  source                                            = "./foundation"
  hcloud_token                                      = var.hcloud_token
  hetzner_dns_api_token                             = var.hetzner_dns_api_token
  main_domain_name                                  = var.main_domain_name
  aws_secret_key                                    = var.aws_secret_key
  aws_account_region                                = var.aws_account_region
  aws_access_key                                    = var.aws_access_key
  gitlab_admin_username                             = var.gitlab_admin_username
  gitlab_root_password                              = var.gitlab_root_password
  gitlab_admin_email                                = var.gitlab_admin_email
  gitlab_admin_password                             = var.gitlab_admin_password
  gitlab_self_signed_cert_country                   = var.gitlab_self_signed_cert_country
  gitlab_self_signed_cert_common_name               = var.gitlab_self_signed_cert_common_name
  gitlab_self_signed_cert_organization              = var.gitlab_self_signed_cert_organization
  google_oauth_app_id                               = var.google_oauth_app_id
  google_oauth_app_secret                           = var.google_oauth_app_secret
  wireguard_server_type                             = var.wireguard_server_type
  vpn_ddns_authentication_key_hmac_sha256           = var.vpn_ddns_authentication_key_hmac_sha256
  vpn_server_ipv4_address_in_internal_tools_network = var.vpn_server_ipv4_address_in_internal_tools_network
  vpn_server_ipv4_address_in_vpn_network            = var.vpn_server_ipv4_address_in_vpn_network
  first_vpn_user_ipv4_address_in_vpn_network        = var.first_vpn_user_ipv4_address_in_vpn_network
}

module "gitlab" {
  source                                            = "./gitlab"
  hcloud_token                                      = var.hcloud_token
  hetzner_dns_api_token                             = var.hetzner_dns_api_token
  vpn_ddns_authentication_key_hmac_sha256           = var.vpn_ddns_authentication_key_hmac_sha256
  gitlab_ipv4_address_in_vpn_network                = var.gitlab_ipv4_address_in_vpn_network
  gitlab_ipv4_address_in_internal_tools_network     = var.gitlab_ipv4_address_in_internal_tools_network
  main_domain_name                                  = var.main_domain_name
  smtp_username                                     = module.foundation.internal_smtp_username
  smtp_password                                     = module.foundation.internal_smtp_password
  smtp_server_address                               = module.foundation.internal_smtp_server_address
  internal_tools_network_id                         = module.foundation.internal_tools_network.id
  internal_tools_subnet                             = module.foundation.internal_tools_subnet
  main_dns_zone_id                                  = module.foundation.main_dns_zone.id
  wireguard_ssh_admin_private_key                   = module.foundation.wireguard_ssh_admin_private_key
  gitlab_admin_username                             = var.gitlab_admin_username
  gitlab_root_password                              = var.gitlab_root_password
  gitlab_admin_email                                = var.gitlab_admin_email
  gitlab_admin_password                             = var.gitlab_admin_password
  gitlab_self_signed_cert_country                   = var.gitlab_self_signed_cert_country
  gitlab_self_signed_cert_common_name               = var.gitlab_self_signed_cert_common_name
  gitlab_self_signed_cert_organization              = var.gitlab_self_signed_cert_organization
  google_oauth_app_id                               = var.google_oauth_app_id
  google_oauth_app_secret                           = var.google_oauth_app_secret
  wireguard_vpn_peer_public_key                     = module.foundation.wireguard_vpn_peer_public_key
  vpn_server_ipv4_address_in_internal_tools_network = var.vpn_server_ipv4_address_in_internal_tools_network
  vpn_server_ipv4_address_in_vpn_network            = var.vpn_server_ipv4_address_in_vpn_network
  gitlab_server_type                                = var.gitlab_server_type
}

module "gitlab_runners" {
  source                                        = "./gitlab_runners"
  hcloud_token                                  = var.hcloud_token
  hetzner_dns_api_token                         = var.hetzner_dns_api_token
  main_domain_name                              = var.main_domain_name
  gitlab_admin_api_personal_access_token        = var.gitlab_admin_api_personal_access_token
  gitlab_runner_docker_executor_count           = var.gitlab_runner_docker_executor_count
  gitlab_ipv4_address_in_internal_tools_network = var.gitlab_ipv4_address_in_internal_tools_network

  internal_tools_network = module.foundation.internal_tools_network
}

module "gitlab_settings" {
  source                                 = "./gitlab_settings"
  main_domain_name                       = var.main_domain_name
  gitlab_admin_api_personal_access_token = var.gitlab_admin_api_personal_access_token
}

module "iam" {
  source                                 = "./iam"
  main_domain_name                       = var.main_domain_name
  google_admin_customer_id               = var.google_admin_customer_id
  gitlab_admin_api_personal_access_token = var.gitlab_admin_api_personal_access_token
  vpn_server_ipv4_address_in_vpn_network = var.vpn_server_ipv4_address_in_vpn_network

  wireguard_vpn_peer_public_key = module.foundation.wireguard_vpn_peer_public_key
  internal_smtp_username        = module.foundation.internal_smtp_username
  internal_smtp_password        = module.foundation.internal_smtp_password
  internal_smtp_server_address  = module.foundation.internal_smtp_server_address
  internal_smtp_server_port     = module.foundation.internal_smtp_server_port
}
