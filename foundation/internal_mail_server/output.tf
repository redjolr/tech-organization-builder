output "smtp_settings" {
  value = {
    username       = aws_iam_access_key.smtp_user_access_key.id,
    password       = aws_iam_access_key.smtp_user_access_key.ses_smtp_password_v4
    server_address = "email-smtp.${var.aws_account_region}.amazonaws.com"
  }
}

output "smtp_username" {
  value = aws_iam_access_key.smtp_user_access_key.id
}

output "smtp_password" {
  sensitive = true
  value     = aws_iam_access_key.smtp_user_access_key.ses_smtp_password_v4
}
