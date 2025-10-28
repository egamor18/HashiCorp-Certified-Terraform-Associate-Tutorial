##############################################
# PROVIDER CONFIGURATION
##############################################

locals {
  environment = "dev"
}

provider "vault" {
  address = "http://127.0.0.1:8200"

  #token   = "PROVIDED THROUGH ENVIRONMENT VARIABLE"
}

data "vault_kv_secret_v2" "aws_creds" {
  mount = "secret"
  name  = "aws_creds"
}

# we retrive the credentials from the vault
provider "aws" {
  region     = "us-east-1"
  access_key = data.vault_kv_secret_v2.aws_creds.data["access_key"]
  secret_key = data.vault_kv_secret_v2.aws_creds.data["secret_key"]

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

output "instance_id" {
  value = aws_instance.web.id
}
