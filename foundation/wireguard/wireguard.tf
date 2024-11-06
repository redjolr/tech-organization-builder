resource "hcloud_primary_ip" "wireguard_primary_ip" {
  name          = "wireguard_ip"
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
  datacenter    = "nbg1-dc3" #"fsn1-dc14"
}

resource "tls_private_key" "ssh_root" {
  algorithm = "ED25519"
}

resource "tls_private_key" "ssh_admin" {
  algorithm = "ED25519"
}

# Create a SSH hetzner keys
resource "hcloud_ssh_key" "wireguard_root_ssh_key" {
  name       = "Wireguard root ssh key"
  public_key = tls_private_key.ssh_root.public_key_openssh
}

# Create a SSH hetzner keys
resource "hcloud_ssh_key" "wireguard_admin_ssh_key" {
  name       = "Wireguard admin user ssh key"
  public_key = tls_private_key.ssh_admin.public_key_openssh
}


# Writes the public key to a file. The file will be written in the secrets directory
resource "local_file" "wireguard_ssh_root_pub_key_in_secrets" {
  content  = tls_private_key.ssh_root.public_key_openssh
  filename = "./secrets/wireguard_root_id_ed25519.pub"
}
resource "local_file" "wireguard_ssh_admin_pub_key_in_secrets" {
  content  = tls_private_key.ssh_admin.public_key_openssh
  filename = "./secrets/wireguard_admin_id_ed25519.pub"
}

# Writes the private key to a file. The file will be written in the secrets directory
resource "local_file" "wireguard_ssh_root_priv_key_in_secrets" {
  content  = tls_private_key.ssh_root.private_key_openssh
  filename = "./secrets/wireguard_root_id_ed25519"
}

resource "local_file" "wireguard_ssh_admin_priv_key_in_secrets" {
  content  = tls_private_key.ssh_admin.private_key_openssh
  filename = "./secrets/wireguard_admin_id_ed25519"
}



resource "wireguard_asymmetric_key" "wireguard_server_peer_key_pair" {
}

resource "wireguard_asymmetric_key" "first_vpn_user_peer_key_pair" {
}

# Create a server
resource "hcloud_server" "wireguard" {
  name         = "wireguard"
  image        = "debian-12"
  server_type  = var.wireguard_server_type
  datacenter   = "nbg1-dc3"
  ssh_keys     = [hcloud_ssh_key.wireguard_root_ssh_key.id, hcloud_ssh_key.wireguard_admin_ssh_key.id]
  firewall_ids = [hcloud_firewall.wireguard_firewall.id]
  lifecycle {
    ignore_changes = [ssh_keys, user_data]
  }
  user_data = templatefile(
    "${path.module}/wireguard-cloud-init.yaml.tftpl",
    {
      main_domain_name                                  = var.main_domain_name,
      vpn_ddns_authentication_key_hmac_sha256           = var.vpn_ddns_authentication_key_hmac_sha256,
      vpn_server_ipv4_address_in_internal_tools_network = var.vpn_server_ipv4_address_in_internal_tools_network
      vpn_server_ipv4_address_in_vpn_network            = var.vpn_server_ipv4_address_in_vpn_network
      ssh_root_authorized_key                           = tls_private_key.ssh_root.public_key_openssh,
      ssh_admin_authorized_key                          = tls_private_key.ssh_admin.public_key_openssh,
      wireguard_server_peer_private_key                 = wireguard_asymmetric_key.wireguard_server_peer_key_pair.private_key
      first_vpn_user_peer_public_key                    = wireguard_asymmetric_key.first_vpn_user_peer_key_pair.public_key
      first_vpn_user_ipv4_address_in_vpn_network        = var.first_vpn_user_ipv4_address_in_vpn_network
    }
  )
  public_net {
    ipv4 = hcloud_primary_ip.wireguard_primary_ip.id
  }
  network {
    network_id = var.internal_tools_network_id
    ip         = var.vpn_server_ipv4_address_in_internal_tools_network
  }
  depends_on = [
    var.internal_tools_subnet
  ]
}

resource "local_file" "first_vpn_user_wireguard_config" {
  content  = <<EOT
[Interface]
PrivateKey = ${wireguard_asymmetric_key.first_vpn_user_peer_key_pair.private_key}
Address = ${var.first_vpn_user_ipv4_address_in_vpn_network}/32
DNS = ${var.vpn_server_ipv4_address_in_vpn_network}

[Peer]
PublicKey = ${wireguard_asymmetric_key.wireguard_server_peer_key_pair.public_key}
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = wireguard.internal.${var.main_domain_name}:51820
  EOT
  filename = "${path.cwd}/secrets/wireguard_conf_files/first_vpn_user_wireguard.config"
}

resource "local_file" "wireguard_ssh_config" {
  content    = <<EOT
Host wireguard
  Hostname wireguard.internal.${var.main_domain_name}
  User root
  IdentityFile ./secrets/wireguard_root_id_ed25519
  IdentitiesOnly yes

Host wireguard
  Hostname wireguard.internal.${var.main_domain_name}
  User admin
  IdentityFile ./secrets/wireguard_admin_id_ed25519
  IdentitiesOnly yes
  EOT
  filename   = "${path.cwd}/.ssh_configs/wireguard_ssh_config"
  depends_on = [hcloud_server.wireguard]
}


resource "hetznerdns_record" "wireguard_a_record" {
  zone_id = var.main_dns_zone_id
  name    = "wireguard.internal"
  value   = hcloud_server.wireguard.ipv4_address
  type    = "A"
  ttl     = 3600
}

resource "time_sleep" "wait_2_minutes" {
  depends_on      = [hcloud_server.wireguard]
  create_duration = "120s"
}

