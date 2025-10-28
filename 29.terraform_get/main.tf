

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Using a local module
module "storage" {
  source = "./modules/s3_bucket"

  bucket_name       = "terraform-get-demo-bucket-gamor-5"
  enable_versioning = true
}
