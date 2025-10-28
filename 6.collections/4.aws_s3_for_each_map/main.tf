#this example creates bucket in aws s3

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "example" {
  for_each = var.buckets

  bucket = each.value

  tags = {
    Name = each.key
    Environment = "dev"
  }
}

output "bucket_names" {
  value = [for b in aws_s3_bucket.example : b.bucket]
}

