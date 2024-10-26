# Set the 2FA settings
resource "gitlab_application_settings" "gitlab_settings" {
  default_branch_name               = "main"
  require_two_factor_authentication = true
  two_factor_grace_period           = 168 # 1 week

  first_day_of_week            = 1 # Sets monday as first day of week
  password_lowercase_required  = true
  password_number_required     = true
  password_symbol_required     = true
  password_uppercase_required  = true
  personal_access_token_prefix = "personal_acc_token_"
}
