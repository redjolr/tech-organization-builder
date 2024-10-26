resource "hetznerdns_record" "google_mx_record" {
  zone_id = module.dns.main_dns_zone.id
  name    = "@"
  value   = "1 SMTP.GOOGLE.COM."
  type    = "MX"
  ttl     = 3600
}
