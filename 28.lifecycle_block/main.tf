

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0341d95f75f311023"
  instance_type = "t3.micro"

  tags = {  Name = "lifecycle_demo"}
  /*
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
    ignore_changes        = [tags, user_data]
  }
  */
}

