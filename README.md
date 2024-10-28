# Tech Organization Builder

This repository serves as a framework to help you establish the technological foundation of your new tech organization.

This open-source framework is your go-to guide for building a solid tech foundation for your organization—whether you’re launching a startup, running a software house, or just working on a personal project. It takes the guesswork out of setting up essential resources like Google Workspace, Hetzner Cloud, VPNs, on-premise cloud installations, mail servers, Gitlab installation, Gitlab runners, and networks.

Designed with ease of use in mind, this framework walks you through each step, making it simple to get everything up and running quickly. You won’t just get a bunch of technical instructions; you’ll also learn best practices to keep your organization secure and efficient as you grow.

## Step 0: Install tools and set up the terraform backend

1. [Task](https://taskfile.dev/)
2. [Terraform](https://www.terraform.io/)

## Step 1: Creating the Organization Admin Email

Create a generic, non-domain-specific email account, ideally with a common provider such as Gmail or Outlook. This email should avoid personal identifiers and instead reflect a neutral, administrative purpose. For example: `organization-admin@outlook.com`.

This "Organization Admin Email" will serve as the primary, root account for setting up and managing services like Google Workspace, Hetzner, AWS, and other essential platforms for your organization.

## Step 2: Purchase a Domain

Buy a domain for your organization through your preferred domain registrar. The domain name will be later stored in the `main_domain_name` variable.

## Step 3: Set up AWS account

1. **Open an AWS Account**  
   Register a new AWS account using your "Organization Admin Email" and mark it as an organizational account.
2. **Enable MFA**  
   Set up Multi-Factor Authentication (MFA) to enhance account security.

3. **Create IAM Policy**
   Define an IAM policy called `automated-provisioning-policy` with the following permissions:

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "VisualEditor0",
         "Effect": "Allow",
         "Action": [
           "iam:GenerateCredentialReport",
           "iam:GetAccountPasswordPolicy",
           "iam:UpdateCloudFrontPublicKey",
           "iam:GetServiceLastAccessedDetailsWithEntities",
           "iam:ListServerCertificates",
           "iam:SetSTSRegionalEndpointStatus",
           "iam:GetServiceLastAccessedDetails",
           "iam:ListVirtualMFADevices",
           "iam:GetOrganizationsAccessReport",
           "iam:SetSecurityTokenServicePreferences",
           "iam:UpdateAccountName",
           "iam:SimulateCustomPolicy",
           "iam:GetAccountEmailAddress",
           "iam:GetCloudFrontPublicKey",
           "iam:CreateAccountAlias",
           "iam:UpdateAccountEmailAddress",
           "iam:GetAccountAuthorizationDetails",
           "iam:DeleteCloudFrontPublicKey",
           "iam:DeleteAccountAlias",
           "iam:GetCredentialReport",
           "iam:ListPolicies",
           "iam:DeleteAccountPasswordPolicy",
           "iam:ListSAMLProviders",
           "iam:ListCloudFrontPublicKeys",
           "iam:ListRoles",
           "iam:ListInstanceProfiles",
           "iam:UploadCloudFrontPublicKey",
           "iam:GetContextKeysForCustomPolicy",
           "iam:UpdateAccountPasswordPolicy",
           "iam:ListOpenIDConnectProviders",
           "iam:GetAccountName",
           "iam:ListAccountAliases",
           "iam:ListUsers",
           "iam:ListGroups",
           "iam:ListSTSRegionalEndpointsStatus",
           "iam:GetAccountSummary",
           "iam:CreateUser",
           "iam:GetUser",
           "iam:ListGroupsForUser",
           "iam:DeleteUser",
           "iam:AttachUserPolicy",
           "iam:ListAttachedUserPolicies",
           "iam:CreateAccessKey",
           "iam:DetachUserPolicy",
           "iam:ListAccessKeys",
           "iam:DeleteAccessKey",
           "iam:CreatePolicy",
           "iam:GetPolicyVersion",
           "iam:GetPolicy",
           "iam:ListPolicyVersions",
           "iam:DeletePolicy",
           "iam:CreateRole",
           "iam:AttachRolePolicy",
           "iam:PutRolePolicy",
           "iam:CreateUser",
           "ses:*",
           "s3:*",
           "dynamodb:*",
           "kms:*"
         ],
         "Resource": "*"
       }
     ]
   }
   ```

4. **Create a User Group**
   Set up a user group called `automated-provisioning-users`.
5. **Create an IAM User**
   Add an IAM user named `terraform-provisioner` to the `automated-provisioning-users` group. This user should not have access to the AWS Management Console.
6. **Generate Access Keys**
   Go to the terraform-provisioner user and create an access key. Use a description like "Provision AWS SES for organization."

   - Save the Access Key in a secure location, as you'll need it later to set the `aws_access_key` variable.
   - Save the Secret Access Key securely as well, as it will be required later to set the `aws_secret_key` variable.

7. **SES Sandbox to Production**
   By default, AWS SES is in a sandbox mode, where you can only send emails to verified addresses. You can request production access later if broader email access is required.

## Step 4: Set up hetzner account

1. **Create a Hetzner Account**
   Register for a Hetzner account using your Organization Admin Email. Use your accurate personal information during registration, as Hetzner may need to verify your identity. Providing accurate details helps avoid potential issues.

2. **Verify Your Identity**
   Complete Hetzner's identity verification process, which may require a passport photo or PayPal verification. This process can take some time. To begin verification, visit: https://accounts.hetzner.com.

3. **Generate an API Access Token**
   Within your Hetzner project, create an API access token named `terraform-provisioner` with read and write permissions. Save this token securely, as you will later assign it to the `hcloud_token` variable.

## Step 5: Setting up Google Workspace

1. **Create a Google Workspace Account**
   Start by using your Organization Admin Email to create the Google Workspace account. This will be the initial email address specified during setup.

2. **Choose Your Sign-In Email Address**
   During the setup, you'll be prompted to choose a custom sign-in email address that uses your domain name. Set this as `admin@yourdomain.tld`.

3. **Add the TXT Record for Domain Verification**
   Follow Google’s instructions to add a TXT record to your domain's DNS settings with your registrar. This step verifies your ownership of the domain.

4. **Add the MX Record for Email Functionality**
   Add the recommended MX records in your domain registrar's DNS settings to enable Google Workspace email functionality for your domain.

## Step 6: Enable programmatic access of the Google API

1.  **Enable Service Account Key Creation**

    - Log in as `admin@yourdomain.tld` and go to Google Cloud Console. Create a new project for your organization.

    - In the "IAM & Admin" section, ensure you're viewing the dashboard at the organization level (not at the project or folder level). Assign the "Organization Policy Administrator" role to `admin@yourdomain.tld`.

    - Navigate to **IAM & Admin** > **Organization Policies**. Locate the constraint **iam.disableServiceAccountKeyCreation** and disable it.

2.  **Create a Service Account**

    - Using the admin account, create a service account at the organization level following this https://developer.hashicorp.com/terraform/tutorials/it-saas/google-workspace.

    - Run the following command as admin@yourdomain.tld:

    ```
    python3 <(curl -s -S -L https://raw.githubusercontent.com/hashicorp/learn-terraform-google-workspace/main/gw-service-account.py)
    ```

    - Follow all prompts in the script and download the generated service account key file, storing it securely.

3.  **Save the Service Account Key**
    - Create a file named `admin_service_account_key.json` in the secrets directory of your project.
    - Copy the contents of the downloaded key file into `admin_service_account_key.json`.

## Step 7: Enable OAuth for GitLab in Google

1. **Open Google Cloud Resource Manager**  
   Log in as `admin@domain.tld` and go to https://console.cloud.google.com/cloud-resource-manager.

2. **Create a Project**
   - Select **CREATE PROJECT**.
   - Enter "GitLab" as the **Project name**.
   - You can either use the randomly generated **Project ID** or create a custom one. Custom IDs must be unique across all Google Developer registered applications.
3. **Set Up the OAuth Consent Screen**

   - Go to https://console.developers.google.com/apis/dashboard.
   - Select your GitLab project from the upper-left corner.
   - In the left menu, choose **OAuth consent screen** and complete the required fields, selecting **User Type: Internal**.

4. **Create OAuth Credentials**
   - Navigate to the **Credentials** menu and select **Create Credentials** > **OAuth client ID**.
   - Fill in the following fields:
     - **Application type**: Choose **Web application**.
     - **Name**: Enter "GitLab Web Application".
     - **Authorized JavaScript origins**: Enter `https://gitlab.internal.${main_domain_name}`.
     - **Authorized redirect URIs**: Add the following URIs one at a time:
       ```
       https://gitlab.internal.${main_domain_name}/users/auth/google_oauth2/callback
       https://gitlab.internal.${main_domain_name}/-/google_api/auth/callback
       ```
5. **Save Client ID and Secret**  
   After creating the credentials, be sure to note the **Client ID** and **Client Secret**, as you'll need them for later steps. During the `task init` phase of this tutorial, you will be prompted to set the `google_oauth_app_id` and `google_oauth_app_secret` variables. Use the **Client ID** for the `google_oauth_app_id` and the **Client Secret** for the `google_oauth_app_secret`.

## Step 8: Enforce 2FA in google workspace

TODO

## Step 9: Execute the Init Task

1. **Run the Init Command**  
   Execute the command `task init`. You will be prompted to enter values for various variables that define your organization's parameters and necessary configurations for automating resource provisioning. This operation will generate four configuration files:

   - **configuration.auto.tfvars**: Contains general, non-sensitive configurations.
   - **secrets.auto.tfvars**: Includes sensitive information and is ignored by Git; ensure you store this file securely.
   - **gitlab.auto.tfvars**: Contains variables specific to GitLab.
   - **google.auto.tfvars**: Contains variables specific to Google.

2. **Commit the Changes**  
   Commit the changes generated in the previous step to your version control system.

## Step 10: Deploy AWS S3 and DynamoDB for Terraform Backend

1. **Initialize Terraform Backend**  
   Run the command `task init-terraform-backend`. This task will create the required AWS S3 bucket and DynamoDB table, enabling us to use S3 as the Terraform backend moving forward.

   At this stage, the state will still be stored locally. In the next step, we will migrate this state to your newly created S3 bucket.

   Additionally, this task will generate the `s3_backend.tf` file, which contains the necessary configuration for using S3 as the backend.

2. **Commit the Changes**  
   Commit the changes generated from the previous step to your version control system.

## Step 11: Deploy the Foundation Resources

1. **Update Your Domain's Nameservers**  
   Point the nameservers from your domain registrar to Hetzner DNS by adding the following hostnames as the nameservers for your domain:

   - `helium.ns.hetzner.de`
   - `hydrogen.ns.hetzner.com`
   - `oxygen.ns.hetzner.com`

2. **Deploy Foundation Resources**  
   Execute the command `task deploy-foundation`.

3. **Respond to Terraform Prompt**  
   You will be prompted by Terraform with the following question:

   ```
   Do you want to copy existing state to the new backend?
     Pre-existing state was found while migrating the previous "local" backend to the
     newly configured "s3" backend. No existing state was found in the newly
     configured "s3" backend. Do you want to copy this state to the new "s3"
     backend? Enter "yes" to copy and "no" to start with an empty state.

     Enter a value:
   ```

   Respond with `yes`.

   During this step, the following actions will occur:

   - The Terraform state that was previously stored locally will be migrated to the S3 bucket you created in the previous step.
   - The main resources for your organization will be created, including the network, WireGuard VPN server, DNS records, and AWS SES mail server.
   - A WireGuard VPN configuration will be generated for the first user that connects to the VPN, stored at `secrets/wireguard_conf_files/first_vpn_user_wireguard.config`.
   - A Google MX record will be added to your domain's DNS zone, enabling Google Workspace to receive emails.

4. **Connect to the WireGuard VPN**  
   Use the WireGuard configuration file located at `secrets/wireguard_conf_files/first_vpn_user_wireguard.config` to connect to the WireGuard VPN. Refer to WireGuard's website for instructions based on your operating system.

## Step 12: Deploy Gitlab

1. Make sure you are connected to the VPN.
2. Execute `deploy-gitlab`
3. Wait for about 10 minutes, because the Gitlab installation continues well after the Server has been created. Cloud init works in the background. Navigate to `https://gitlanb.internal.${main_domain_name}` and keep refreshing until Gitlab is live.

## Step 12: Configure GitLab

1. Log in to GitLab using the superadmin account.
2. Set up two-factor authentication (2FA) for the superadmin account.
3. Generate a personal access token with the `api` scope and store it in the `gitlab_admin_api_personal_access_token` variable of the `secrets.auto.tfvars` file.

4. Apply the `gitlab_settings` Terraform module immediately after deploying GitLab:

   ```bash
   task apply-gitlab-settings
   ```

   This will enforce the following settings for your GitLab installation:

   - Immediately enforce 2FA for all users moving forward.
   - Set `main` as the default branch for all new repositories.
