terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
  required_version = ">= 1.1.6"
}


resource "hcloud_network" "internal_tools_network" {
  name     = "internal_tools_network"
  ip_range = "172.16.0.0/20" # 4094 available hosts. 
}


resource "hcloud_network_subnet" "internal_tools_subnet" {
  network_id   = hcloud_network.internal_tools_network.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "172.16.0.0/20"
}
