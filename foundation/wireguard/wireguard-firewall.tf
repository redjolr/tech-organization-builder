
// Wireguard needs only port 51829 over UDP
resource "hcloud_firewall" "wireguard_firewall" {
  name = "wireguard_firewall"

  rule {
    direction       = "out"
    protocol        = "udp"
    port            = "51820"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction = "in"
    protocol  = "udp"
    port      = "51820"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}
