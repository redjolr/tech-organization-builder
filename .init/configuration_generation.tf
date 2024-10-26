resource "random_bytes" "vpn_ddns_authentication_key_hmac_sha256" {
  length = 32
}

resource "random_password" "gitlab_root_password" {
  length           = 30
  lower            = true
  upper            = true
  numeric          = true
  special          = true
  override_special = "!#$%&*?.+-_"
}


resource "random_password" "gitlab_admin_password" {
  length           = 30
  lower            = true
  upper            = true
  numeric          = true
  special          = true
  override_special = "!#$%&*?.+-_"
}

resource "local_file" "configuration_auto_tfvars" {
  content  = <<EOT
main_domain_name      = "${var.main_domain_name}"
wireguard_server_type = "${var.is_test_organization == "yes" ? "cx22" : "ccx13"}"
gitlab_server_type    = "${var.is_test_organization == "yes" ? "cx32" : "ccx23"}"
aws_account_region    = "${var.aws_account_region}"
  EOT
  filename = "${path.cwd}/configuration.auto.tfvars"

  lifecycle {
    ignore_changes = [
      content
    ]
  }
}



resource "local_file" "secrets_auto_tfvars" {
  content  = <<EOT
hcloud_token                            = "${var.hcloud_token}"
hetzner_dns_api_token                   = "${var.hetzner_dns_api_token}"
aws_access_key                          = "${var.aws_access_key}"
aws_secret_key                          = "${var.aws_secret_key}"
vpn_ddns_authentication_key_hmac_sha256 = "${random_bytes.vpn_ddns_authentication_key_hmac_sha256.base64}"
gitlab_root_password                    = "${random_password.gitlab_root_password.result}"
gitlab_admin_password                   = "${random_password.gitlab_admin_password.result}"
google_oauth_app_secret                 = "${var.google_oauth_app_secret}"
google_oauth_app_id                     = "${var.google_oauth_app_id}"
gitlab_admin_api_personal_access_token  = ""

  EOT
  filename = "${path.cwd}/secrets.auto.tfvars"

  lifecycle {
    ignore_changes = [
      content
    ]
  }
}

resource "local_file" "gitlab_auto_tfvars" {
  content  = <<EOT
gitlab_hostname                      = "gitlab.internal.${var.main_domain_name}"
gitlab_self_signed_cert_country      = "${var.gitlab_self_signed_cert_country}"
gitlab_self_signed_cert_common_name  = "${var.main_domain_name}"
gitlab_self_signed_cert_organization = "${var.gitlab_self_signed_cert_organization}"
gitlab_admin_username                = "superadmin"
gitlab_admin_email                   = "${var.organization_admin_email}"
gitlab_runner_docker_executor_count  = 1

  EOT
  filename = "${path.cwd}/gitlab.auto.tfvars"

  lifecycle {
    ignore_changes = [
      content
    ]
  }
}

resource "local_file" "google_auto_tfvars" {
  content  = <<EOT
google_admin_customer_id  = "${var.google_admin_customer_id}"
  EOT
  filename = "${path.cwd}/google.auto.tfvars"

  lifecycle {
    ignore_changes = [
      content
    ]
  }
}
