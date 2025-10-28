
provider "aws" {
  region = "us-east-1"
}

# Create these two resources
resource "aws_s3_bucket" "demo_bucket" {
  #bucket = "demo-import-bucket-gamor"
  bucket = "terraform-import-demo-gamor"
}

# This fetches the ubuntu image id
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
}

# -------------------------------
# Output the data for verification
# -------------------------------
output "ubuntu_ami" {
  value = data.aws_ami.ubuntu.id
}

