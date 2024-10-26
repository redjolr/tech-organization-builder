variable "is_test_organization" {
  description = "Is this a test organization? (yes/no):"
  validation {
    condition     = contains(["yes", "no"], var.is_test_organization)
    error_message = "The only valid responses are yes and no."
  }
}

variable "main_domain_name" {
  description = <<-EOF
    The domain name you purchased from a domain registrar.
    Example: "example.com", "myorg.de", "abc.net".
  EOF
  type        = string
}

variable "organization_admin_email" {
  description = <<-EOF
    The Organization Admin email address that you used to create the Hetzner and AWS accounts.
    It will also be the email address of the Gitlab's superadmin account.  
  EOF
  type        = string
}

variable "hcloud_token" {
  description = <<-EOF
    This is the Hcloud token you generated in your Hetzner account. If you don't have a token yet, 
    you can create one through the Hetzner Cloud Console.

    Log in to Hetzner using your organization's admin email address.
    Go to Security > API Tokens and click Generate API Token.
    Choose a name for the token, such as "terraform-provisioner", and ensure it has Read and Write permissions.
    This token will be essential for provisioning Hetzner resources using Terraform.
  EOF
  type        = string
  sensitive   = true
}

variable "hetzner_dns_api_token" {
  description = <<-EOF
    This is the Hcloud token you generated in your Hetzner DNS console. If you don't have a token yet, 
    you can create one through the Hetzner DNS Console.

    Log in to Hetzner using your organization's admin email address.
    Go to the DNS console. Click on Manage API tokens. Choose a name for your token and click on Create Access Token.
    This token will be essential for provisioning Hetzner DNS zones and records.
  EOF
  type        = string
  sensitive   = true
}

variable "aws_account_region" {
  type = string
}

variable "aws_access_key" {
  description = <<-EOF
    This is the AWS Access Key required to create resources in AWS, used together with the AWS Secret Key.

    As described in the README.md, you should have created an IAM user named terraform-provisioner. 
    Now, create an access key for this user:

    - In the AWS Management Console, go to IAM > Users, select terraform-provisioner, and click Security credentials.
    - Generate a new access key, and be sure to save both the Access Key ID and Secret Access Key.
    When prompted:

    For the aws_access_key variable, enter the Access Key ID.
    For the aws_secret_key variable, enter the Secret Access Key.
    These credentials allow Terraform to interact securely with AWS to provision resources.
  EOF
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = <<-EOF
    This is the AWS Secret Key required to create resources in AWS, used together with the AWS Access Key.

    As described in the README.md, you should have created an IAM user named terraform-provisioner. 
    Now, create an access key for this user:

    - In the AWS Management Console, go to IAM > Users, select terraform-provisioner, and click Security credentials.
    - Generate a new access key, and be sure to save both the Access Key ID and Secret Access Key.
    When prompted:

    For the aws_access_key variable, enter the Access Key ID.
    For the aws_secret_key variable, enter the Secret Access Key.
    These credentials allow Terraform to interact securely with AWS to provision resources.
  EOF
  type        = string
  sensitive   = true
}


variable "gitlab_self_signed_cert_country" {
  description = <<-EOF
    During the GitLab installation, a self-signed SSL certificate will be generated to secure 
    communication with GitLab. This certificate requires some information to identify your organization.
    For this variable, enter your country code using the ISO 3166-1 alpha-2 standard (e.g., AL, DE, US, CN).
  EOF
  type        = string
}

variable "gitlab_self_signed_cert_organization" {
  description = <<-EOF
    Enter your organization's name, so that it can be shown in the self signed Certificate.
    Examples: MyAwesomeName, Google, Meta. 
  EOF
  type        = string
}

variable "google_admin_customer_id" {
  description = <<-EOF
    Logged in as `admin@yourdomain.tld` navigate to this url: https://admin.google.com/u/0/ac/accountsettings
    Find the "Customer Id" and pass it to this variable.
  EOF
  type        = string
}

variable "google_oauth_app_id" {
  description = <<-EOF
    Pass the Google OAuth client Id as generated in step "Enabling OAuth in Google for Gitlab" 
  EOF
  type        = string
}

variable "google_oauth_app_secret" {
  description = <<-EOF
    Pass the Google OAuth client Secret as generated in step "Enabling OAuth in Google for Gitlab" 
  EOF
  type        = string
}
