


provider "aws" {
  region = "us-east-1"
}

/*
resource "aws_s3_bucket" "old_bucket" {
  bucket = "demo-moved-block-example-gamor"
}

*/

# we rename the bucket
resource "aws_s3_bucket" "new_bucket" {
  bucket = "demo-moved-block-example-gamor"
}

moved {
  from = aws_s3_bucket.old_bucket
  to   = aws_s3_bucket.new_bucket
}