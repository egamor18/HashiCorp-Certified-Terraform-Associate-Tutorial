terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "terraform-s3-backend-authentication-demo-gamor"    
    key = "terraform/state/terraform.tfstate"     #s3 storage path
    region = "us-east-1"
  }
}

