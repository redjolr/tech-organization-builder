source "hcloud" "base-amd64" {
  image         = "debian-12"
  location      = "nbg1"#"fsn1"
  server_type   = var.gitlab_server_type
  ssh_keys      = []
  user_data     = ""
  ssh_username  = "root"
  snapshot_name = "gitlab-image"
  snapshot_labels = {
    base    = "debian-12",
    version = "v1.0.0",
    image-name    = "gitlab17"
  }
}

variable "gitlab_hostname" {
  type    = string
}

variable "gitlab_self_signed_cert_country" {
  type = string
}
variable "gitlab_self_signed_cert_common_name" {
  type = string
}
variable "gitlab_self_signed_cert_organization" {
  type = string
}
variable "gitlab_server_type" {
  type = string
}

build {
  sources = ["source.hcloud.base-amd64"]
  provisioner "shell" {
    inline = [
      "apt-get update",
      "sudo apt-get install -y curl openssh-server ca-certificates perl",
      "sudo apt-get install -y postfix",
      "curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash",
      "sudo EXTERNAL_URL=\"http://${var.gitlab_hostname}\" apt-get -y install gitlab-ee",
      "sudo mkdir -p /etc/gitlab/ssl",
      "sudo chmod 755 /etc/gitlab/ssl",
      "sudo apt-get install -y openssl",
      "openssl req -nodes -x509 -sha256 -newkey rsa:4096 -keyout /etc/gitlab/ssl/${var.gitlab_hostname}.key -out /etc/gitlab/ssl/${var.gitlab_hostname}.crt -days 3650 -subj \"/C=DE/ST=Bavaria/L=Munich/O=VolksAI/OU=IT/CN=${var.gitlab_hostname}\" -addext \"subjectAltName = DNS:localhost,DNS:${var.gitlab_hostname}\"",
      "echo 'external_url \"https://${var.gitlab_hostname}\"' >> /etc/gitlab/gitlab.rb",
      "echo \"letsencrypt['enable'] = false\" >> /etc/gitlab/gitlab.rb",
      "echo \"nginx['redirect_http_to_https'] = true\" >> /etc/gitlab/gitlab.rb",
      "sudo gitlab-rails runner \"::Gitlab::CurrentSettings.update!(signup_enabled: false)\""
    ]
    env = {
      BUILDER = "packer"
    }
  }
}