##############################################
# PROVIDER CONFIGURATION
##############################################
locals {
  region = lower(var.region)
  environment = "dev"
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      Environment = local.environment
      Owner       = "Eric"
      Provisioned = "Terraform"
    }
  }
}

##############################################
# FETCH UBUNTU AMI
##############################################
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

##############################################
# EC2 INSTANCE
##############################################
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "workspace-demo-${local.environment}"
  }
}

##############################################
# OUTPUT
##############################################

output "aws_region" {
  value = local.region
}

output "instance_id" {
  value = aws_instance.web.id
}
