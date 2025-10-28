
provider "aws" {
  region = "us-east-1"
}

# Placeholder resource definition (Terraform expects this)
resource "aws_s3_bucket" "demo_bucket" {
  #bucket = "demo-import-bucket-gamor"
  bucket = "terraform-import-demo-gamor"
}

