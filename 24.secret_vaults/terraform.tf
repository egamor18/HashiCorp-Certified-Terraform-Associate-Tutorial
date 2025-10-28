terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.3"
    }
  }
  required_version = ">= 1.2.0"

}
