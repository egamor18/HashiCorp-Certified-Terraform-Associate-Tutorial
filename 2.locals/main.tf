provider "aws" {
  region = "us-east-1"
}

# Define local values
locals {
  environment = "dev"
  project     = "web-app"
  instance_name = "${local.project}-${local.environment}-instance"

  # Common tags used for all resources
  common_tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
}

# Create an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0341d95f75f311023"  # Amazon Linux 2 (example AMI)
  instance_type = "t3.micro"

  tags = merge(
    local.common_tags,
    {
      Name = local.instance_name
    }
  )
}
