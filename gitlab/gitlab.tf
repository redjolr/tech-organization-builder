
resource "hcloud_primary_ip" "gitlab_primary_ip" {
  name          = "gitlab_ip"
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
resource "hcloud_ssh_key" "gitlab_root_ssh_key" {
  name       = "Gitlab root ssh key"
  public_key = tls_private_key.ssh_root.public_key_openssh
}

# Create a SSH hetzner keys
resource "hcloud_ssh_key" "gitlab_admin_ssh_key" {
  name       = "Gitlab admin user ssh key"
  public_key = tls_private_key.ssh_admin.public_key_openssh
}


# Writes the public key to a file. The file will be written in the secrets directory
resource "local_file" "gitlab_ssh_root_pub_key_in_secrets" {
  content  = tls_private_key.ssh_root.public_key_openssh
  filename = "./secrets/gitlab_root_id_ed25519.pub"
}
resource "local_file" "gitlab_ssh_admin_pub_key_in_secrets" {
  content  = tls_private_key.ssh_admin.public_key_openssh
  filename = "./secrets/gitlab_admin_id_ed25519.pub"
}


# Writes the private key to a file. The file will be written in the secrets directory
resource "local_file" "gitlab_ssh_root_priv_key_in_secrets" {
  content  = tls_private_key.ssh_root.private_key_openssh
  filename = "./secrets/gitlab_root_id_ed25519"
}

resource "local_file" "gitlab_ssh_admin_priv_key_in_secrets" {
  content  = tls_private_key.ssh_admin.private_key_openssh
  filename = "./secrets/gitlab_admin_id_ed25519"
}

resource "wireguard_asymmetric_key" "gitlab_vpn_peer_key_pair" {
}



# Create a server
resource "hcloud_server" "gitlab" {
  name        = "gitlab"
  image       = "debian-12" #data.hcloud_image.gitlab_snapshot.id
  server_type = var.gitlab_server_type
  datacenter  = "nbg1-dc3" #"fsn1-dc14"
  ssh_keys    = [hcloud_ssh_key.gitlab_root_ssh_key.id, hcloud_ssh_key.gitlab_admin_ssh_key.id]
  lifecycle {
    ignore_changes = [ssh_keys, user_data]
  }
  user_data = templatefile(
    "${path.module}/gitlab-cloud-init.yaml.tftpl",
    {
      smtp_username                                     = var.smtp_username,
      smtp_password                                     = var.smtp_password,
      smtp_server_address                               = var.smtp_server_address,
      smtp_port                                         = 587,
      main_domain_name                                  = var.main_domain_name,
      gitlab_hostname                                   = "gitlab.internal.${var.main_domain_name}",
      gitlab_root_password                              = var.gitlab_root_password,
      gitlab_admin_email                                = var.gitlab_admin_email,
      gitlab_admin_password                             = var.gitlab_admin_password,
      gitlab_admin_username                             = var.gitlab_admin_username,
      one_year_from_now                                 = formatdate("YYYY-MM-DD", timeadd(timestamp(), "8736h")),
      ssh_root_authorized_key                           = tls_private_key.ssh_root.public_key_openssh,
      ssh_admin_authorized_key                          = tls_private_key.ssh_admin.public_key_openssh,
      google_oauth_app_id                               = var.google_oauth_app_id,
      google_oauth_app_secret                           = var.google_oauth_app_secret
      gitlab_vpn_peer_private_key                       = wireguard_asymmetric_key.gitlab_vpn_peer_key_pair.private_key
      wireguard_vpn_peer_public_key                     = var.wireguard_vpn_peer_public_key
      vpn_server_ipv4_address_in_internal_tools_network = var.vpn_server_ipv4_address_in_internal_tools_network
      vpn_server_ipv4_address_in_vpn_network            = var.vpn_server_ipv4_address_in_vpn_network
      gitlab_ipv4_address_in_vpn_network                = var.gitlab_ipv4_address_in_vpn_network
    }
  )
  public_net {
    # ipv4 = hcloud_primary_ip.gitlab_primary_ip.id
    ipv4_enabled = false
    ipv6_enabled = false
  }
  network {
    network_id = var.internal_tools_network_id
    ip         = var.gitlab_ipv4_address_in_internal_tools_network
  }
  depends_on = [
    var.internal_tools_subnet
  ]

  connection {
    type        = "ssh"
    user        = "admin"
    private_key = var.wireguard_ssh_admin_private_key
    host        = "wireguard.internal.${var.main_domain_name}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo wg set wg0 peer \"${wireguard_asymmetric_key.gitlab_vpn_peer_key_pair.public_key}\"  allowed-ips ${var.gitlab_ipv4_address_in_vpn_network}"
    ]
  }
}


resource "local_file" "gitlab_ssh_config" {
  content    = <<EOT
Host gitlab
  Hostname gitlab.internal.${var.main_domain_name}
  User root
  IdentityFile ./secrets/gitlab_root_id_ed25519
  IdentitiesOnly yes

Host gitlab
  Hostname gitlab.internal.${var.main_domain_name}
  User admin
  IdentityFile ./secrets/gitlab_admin_id_ed25519
  IdentitiesOnly yes
  EOT
  filename   = "${path.cwd}/.ssh_configs/gitlab_ssh_config"
  depends_on = [hcloud_server.gitlab]
}


# resource "hetznerdns_record" "gitlab_a_record" {
#   zone_id = var.main_dns_zone_id
#   name    = "gitlab"
#   value   = hcloud_server.gitlab.ipv4_address
#   type    = "A"
#   ttl     = 3600
# }

resource "dns_a_record_set" "gitlab_a_record_in_vpn" {
  zone      = "internal.${var.main_domain_name}."
  name      = "gitlab"
  addresses = [var.gitlab_ipv4_address_in_vpn_network]
  ttl       = 300
}

