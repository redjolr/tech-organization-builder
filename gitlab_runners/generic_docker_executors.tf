resource "gitlab_user_runner" "docker_executor_runner" {
  count       = var.gitlab_runner_docker_executor_count
  runner_type = "instance_type"

  description = "Generic runner with docker executor ${count.index}."
  tag_list    = ["generic_docker_executor"]
  untagged    = false
}

data "template_file" "cloud_init" {
  count    = var.gitlab_runner_docker_executor_count
  template = file("${path.module}/runner-cloud-init.yaml")
  vars = {
    runner_authentication_token                   = gitlab_user_runner.docker_executor_runner[count.index].token
    main_domain_name                              = var.main_domain_name
    gitlab_ipv4_address_in_internal_tools_network = var.gitlab_ipv4_address_in_internal_tools_network
    gitlab_hostname                               = "gitlab.internal.${var.main_domain_name}"
  }
}

resource "hcloud_server" "gitlab_runner_with_generic_docker_executor_server" {
  count        = var.gitlab_runner_docker_executor_count
  name         = "runner-generic-docker-executor-${count.index}"
  image        = "debian-12"
  firewall_ids = [hcloud_firewall.gitlab_runners_firewall.id]
  server_type  = "ccx13"    # cx11(2GB) cx22(4GB), cx32(8GB), cx42(16GB), cx52(32GB)
  datacenter   = "nbg1-dc3" #"ash-dc1" #"hel1-dc2" #"fsn1-dc14" #"nbg1-dc3"
  lifecycle {
    ignore_changes = [ssh_keys, user_data]
  }
  user_data = data.template_file.cloud_init[count.index].rendered
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
  network {
    network_id = var.internal_tools_network.id
  }
  depends_on = [gitlab_user_runner.docker_executor_runner]
}
