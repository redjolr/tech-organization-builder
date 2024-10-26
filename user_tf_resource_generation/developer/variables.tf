variable "main_domain_name" {
  type = string
}

variable "primary_email" {
  description = "Enter the primary email that will be used by the user in your organization"
  type        = string
}

variable "google_workspace_password" {
  description = "Provide a strong password, which the user will use to log into his google account."
  type        = string
  sensitive   = true
}

variable "first_name" {
  description = "User's first name."
  type        = string
}

variable "last_name" {
  description = "Family name of the user."
  type        = string
}

variable "personal_email" {
  description = "The personal email that can be used to contact the user, if they don't have access to their work organization yet."
  type        = string
}

variable "gitlab_password" {
  description = "The initial password that the user will use to login."
  type        = string
  sensitive   = true
}

variable "user_ipv4_address_in_vpn_network" {
  description = <<EOF
    The VPN network requires that each user is assigned a unique IP address manually. To avoid conflicts, 
    you must check the IP addresses of all existing peers on the WireGuard server before assigning a new one.
    Follow these steps to check the registered peers:
    1. SSH into the WireGuard server by running: task ssh:wireguard-admin
    2. wg show wg0

    Make sure to choose an IP that is not already in use by another peer.
  EOF

  type = string
}
