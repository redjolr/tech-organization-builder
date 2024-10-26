provider "aws" {
  region     = var.aws_account_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "hetznerdns" {
  api_token = var.hetzner_dns_api_token
}

# resource "aws_ses_configuration_set" "ses_config" {
#   name                       = "config_ses"
#   reputation_metrics_enabled = true
# }

resource "aws_ses_domain_identity" "domain_identity" {
  domain = "internal.${var.main_domain_name}"
}

resource "aws_ses_domain_mail_from" "domain_mail_from" {
  domain           = aws_ses_domain_identity.domain_identity.domain
  mail_from_domain = "bounce.${aws_ses_domain_identity.domain_identity.domain}"
}

resource "aws_ses_domain_dkim" "dkim_identity" {
  domain = aws_ses_domain_identity.domain_identity.domain
}

resource "hetznerdns_record" "amazonses_dkim_record" {
  count   = 3
  zone_id = var.main_dns_zone_id
  name    = "${aws_ses_domain_dkim.dkim_identity.dkim_tokens[count.index]}._domainkey.internal"
  type    = "CNAME"
  ttl     = "300"
  value   = "${aws_ses_domain_dkim.dkim_identity.dkim_tokens[count.index]}.dkim.amazonses.com."
}

resource "aws_ses_domain_identity_verification" "domain_identity_verification" {
  domain     = aws_ses_domain_identity.domain_identity.id
  depends_on = [hetznerdns_record.amazonses_dkim_record]
}

resource "hetznerdns_record" "mail_from_mx_record" {
  zone_id = var.main_dns_zone_id
  name    = "bounce.internal"
  type    = "MX"
  ttl     = "600"
  value   = "10 feedback-smtp.${var.aws_account_region}.amazonses.com." # Change to the region in which `aws_ses_domain_identity.example` is created
}

resource "hetznerdns_record" "mail_from_txt_record" {
  zone_id = var.main_dns_zone_id
  name    = "bounce.internal"
  type    = "TXT"
  ttl     = "600"
  value   = "v=spf1 include:amazonses.com. -all"
}


# Example Route53 TXT record for SPF
resource "hetznerdns_record" "dmar_txt_record" {
  zone_id = var.main_dns_zone_id
  name    = "_dmarc.internal"
  type    = "TXT"
  ttl     = "600"
  value   = "v=DMARC1;p=quarantine;rua=mailto:dmarc_report@${aws_ses_domain_identity.domain_identity.domain}"
}


resource "aws_iam_user" "smtp_user" {
  name = "smtp-user"
}

resource "aws_iam_access_key" "smtp_user_access_key" {
  user = aws_iam_user.smtp_user.name
}

data "aws_iam_policy_document" "ses_sender" {
  statement {
    actions   = ["ses:SendRawEmail"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ses_sender" {
  name        = "ses_sender"
  description = "Allows sending of e-mails via Simple Email Service"
  policy      = data.aws_iam_policy_document.ses_sender.json
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.smtp_user.name
  policy_arn = aws_iam_policy.ses_sender.arn
}

resource "local_file" "username" {
  content  = aws_iam_access_key.smtp_user_access_key.id
  filename = "./secrets/smtp_username.txt"
}


resource "local_file" "password" {
  content  = aws_iam_access_key.smtp_user_access_key.ses_smtp_password_v4
  filename = "./secrets/smtp_password.txt"
}
