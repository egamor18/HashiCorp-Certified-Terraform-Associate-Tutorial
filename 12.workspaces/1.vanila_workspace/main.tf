
provider "aws" {
    #region = "us-east-1"

  region = "us-west-2"
  default_tags {
    tags = {
      Environment = terraform.workspace
      Owner       = "Eric"
      Provisoned  = "Terraform"
    }
  }

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

