terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    cato = {
      source  = "registry.terraform.io/catonetworks/cato"
      version = "~> 0.0.23"
    }
  }
  required_version = ">= 0.13"
}
