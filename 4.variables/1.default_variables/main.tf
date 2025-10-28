
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-052064a798f08f0d3"
  instance_type = var.instance_type
}

