

resource "random_string" "terraform_state_s3bucket_name_extension" {
  length  = 5
  special = false
  upper   = false
  lower   = true
  numeric = true
}

locals {
  bucket_name = "terraform-state-of-${replace(var.main_domain_name, "/[_\\.]/", "-")}-${random_string.terraform_state_s3bucket_name_extension.result}"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = local.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.terraform-bucket-key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
