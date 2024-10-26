terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.47.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "aws" {
  region     = var.aws_account_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
