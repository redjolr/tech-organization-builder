provider "hetznerdns" {
  api_token = var.hetzner_dns_api_token
}

resource "hetznerdns_zone" "main_dns_zone" {
  name = var.main_domain_name
  ttl  = 3600
}

