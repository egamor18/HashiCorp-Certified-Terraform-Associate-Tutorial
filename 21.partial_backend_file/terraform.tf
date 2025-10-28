terraform {
  backend "s3" {
    region = "us-east-1"
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }
  required_version = ">= 1.2.0"


  /*
  cloud {
    organization = "nubueke"
    workspaces {
      name    = "cloud-backend"
      project = "my-second-hcp-backend"
    }
  } 
  backend "s3" {
    bucket         = "terraform-s3-backend-authentication-demo-gamor"
    key            = "terraform/state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks" # DynamoDB table used for state locking. This enables state locking
    encrypt        = true              # Optional: encrypt state at rest
  }
*/


}
