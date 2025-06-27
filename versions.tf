terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.98.0"
    }
    cato = {
      source  = "registry.terraform.io/catonetworks/cato"
      version = "~> 0.0.27"
    }
  }
  required_version = ">= 1.5"
}
