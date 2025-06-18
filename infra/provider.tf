terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  backend "local" {}
}

provider "aws" {
  region  = var.aws_region
  # utilise AWS_SHARED_CREDENTIALS_FILE
}