resource "local_file" "new_s3_backend_file" {
  content  = <<EOT
terraform {
 backend "s3" {
   bucket         = "${local.bucket_name}"
   key            = "state/terraform.tfstate"
   region         = "${var.aws_account_region}"
   encrypt        = true
   kms_key_id     = "${aws_kms_alias.key-alias.name}"
   dynamodb_table = "${aws_dynamodb_table.terraform_state.name}"
 }
}
  EOT
  filename = "${path.cwd}/s3_backend.tf"
}
