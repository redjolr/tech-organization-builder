output "internal_tools_network" {
  value = module.network.internal_tools_network
}

output "wireguard_vpn_peer_public_key" {
  value = module.wireguard.wireguard_vpn_peer_public_key
}

output "wireguard_ssh_admin_private_key" {
  value = module.wireguard.wireguard_ssh_admin_private_key
}

output "internal_smtp_username" {
  value = module.internal_mail_server.smtp_settings.username
}

output "internal_smtp_password" {
  value = module.internal_mail_server.smtp_settings.password
}

output "internal_smtp_server_address" {
  value = module.internal_mail_server.smtp_settings.server_address
}

output "internal_smtp_server_port" {
  value = 587
}

output "internal_tools_subnet" {
  value = module.network.internal_tools_subnet
}

output "main_dns_zone" {
  value = module.dns.main_dns_zone
}
