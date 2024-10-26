output "wireguard_vpn_peer_public_key" {
  value = wireguard_asymmetric_key.wireguard_server_peer_key_pair.public_key
}

output "wireguard_ssh_admin_private_key" {
  value = tls_private_key.ssh_admin.private_key_openssh
}
