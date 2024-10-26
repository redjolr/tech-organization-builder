data "template_file" "developer_template" {
  template = file("${path.module}/developer_template.tf.tftpl")
  vars = {
    primary_email                         = var.primary_email,
    main_domain_name                      = var.main_domain_name,
    google_workspace_password             = var.google_workspace_password,
    google_workspace_sha1_hashed_password = sha1(var.google_workspace_password),
    google_workspace_hash_function        = "SHA-1",
    last_name                             = var.last_name,
    first_name                            = var.first_name,
    personal_email                        = var.personal_email,
    gitlab_username                       = lower("${var.first_name}.${var.last_name}"),
    gitlab_password                       = var.gitlab_password
    user_ipv4_address_in_vpn_network      = var.user_ipv4_address_in_vpn_network
  }
}

resource "local_file" "rendered_developer_resources" {
  content  = data.template_file.developer_template.rendered
  filename = "${path.cwd}/iam/users/${var.primary_email}.tf"
}
