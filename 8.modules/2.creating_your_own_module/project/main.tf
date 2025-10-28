# we use the module that we have created
provider "aws" {
  region = "us-east-1"
}

# Using the child module from local path
module "storage" {
  source            = "./terraform-modules/my_s3_bucket_module"
  bucket_name       = "terraform-building-own-module-gamor"
  enable_versioning = true
  tags = {
    Environment = "dev"
    Team        = "data"
  }
}


#here we access the bucket id directly and use it for permissions.
#as long as the child module defines an output block for an attribute,
#we can access it direct in the parent block

resource "aws_s3_bucket_policy" "example" {
  bucket = module.storage.bucket_id  # direct accesss

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = ["s3:GetObject"]
        Effect    = "Allow"
        Resource  = "arn:aws:s3:::${module.storage.bucket_id}/*"
        Principal = "*"
      }
    ]
  })
}
