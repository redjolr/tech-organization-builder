variable "hcloud_token" {
  sensitive = true
}

variable "hetzner_dns_api_token" {
  description = "The API token that you can generate in the DNS console. It is different from the normal API token."
  type        = string
}

variable "internal_tools_network" {
  type = object({
    id                       = number
    name                     = string
    ip_range                 = string
    labels                   = map(any)
    delete_protection        = bool
    expose_routes_to_vswitch = bool
  })
}

variable "main_domain_name" {
  type = string
}

variable "gitlab_admin_api_personal_access_token" {
  type      = string
  sensitive = true
}

variable "gitlab_ipv4_address_in_internal_tools_network" {
  type = string
}

variable "gitlab_runner_docker_executor_count" {
  type = number
}
