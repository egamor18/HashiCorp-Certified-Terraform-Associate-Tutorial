
provider "aws" {
  region = "us-east-1" # default region
}

provider "aws" {
  alias  = "east2"
  region = "us-east-2" # another region
}

provider "aws" {
  alias  = "west"
  region = "us-west-2" # another region
}

provider "aws" {
  alias  = "west1"
  region = "us-west-1" # another region
}


#creating the s3 buckets

#default region
resource "aws_s3_bucket" "default_region" {
  bucket = "my-tf-example-bucket-gamor-default-region"
}

#for us-east-2
resource "aws_s3_bucket" "east2" {
  provider = aws.east2
  bucket   = "my-tf-example-bucket-gamor-us-east-2-region"
}

#for us-west-1
resource "aws_s3_bucket" "west1" {
  provider = aws.west1
  bucket   = "my-tf-example-bucket-gamor-us-west-1-region"
}
