terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.33.0"
    }
  }
  required_version = ">= 0.13"
}

module "aws" {
  source                 = "../aws"
  license_enterprise_key = var.license_enterprise_key
  member_count           = var.member_count
}
