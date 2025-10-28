
/*
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "example" {
  ami           = "ami-052064a798f08f0d3"
  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
  }
}




# -------------------------------
# DATA SOURCE: Read an existing S3 bucket
# -------------------------------
data "aws_s3_bucket" "existing" {
  bucket = "sa.akla-ml-bucket-us-east-1"
}

# -------------------------------
# Use that data in another resource
# -------------------------------
resource "aws_s3_bucket_policy" "allow_access" {

  # id in s3 represent the bucket name.
  bucket = data.aws_s3_bucket.existing.id   
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = ["s3:GetObject"]
        Effect    = "Allow"
        Resource  = "${data.aws_s3_bucket.existing.arn}/*"
        Principal = "*"
      }
    ]
  })
}

# -------------------------------
# Output the data for verification
# -------------------------------
output "bucket_name" {
  value = data.aws_s3_bucket.existing.bucket
}

output "bucket_arn" {
  value = data.aws_s3_bucket.existing.arn
}
*/