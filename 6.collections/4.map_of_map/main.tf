#this example creates bucket in aws s3

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "dev_resource" {
  for_each = var.buckets["dev"]

  bucket = each.value

  tags = {
    Name        = each.key
    Environment = "dev"
  }
}


resource "aws_s3_bucket" "prod_resource" {
  for_each = var.buckets["prod"]

  bucket = each.value

  tags = {
    Name        = each.key
    Environment = "prod"
  }
}


output "bucket_dev" {
  value = [for b in aws_s3_bucket.dev_resource : b.bucket]
}

output "bucket_prod" {
  value = [for b in aws_s3_bucket.prod_resource : b.bucket]
}

