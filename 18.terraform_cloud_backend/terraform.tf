
terraform {

  cloud {

    organization = "nubueke"

    workspaces {
      name    = "cloud-backend"
      project = "my-second-hcp-backend"
    }
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.13.0"
}
