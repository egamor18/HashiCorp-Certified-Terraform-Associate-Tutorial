
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#give me the aws region
data "aws_region" "current" {
}

#fetch the availability zones for me
data "aws_availability_zones" "available" {

}

#Define the VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = var.vpc_name
    Environment = "demo_environment"
    Terraform   = "true"
    Region      = data.aws_region.current.name
  }
}


# -------------------------------
# Output the data for verification
# -------------------------------
output "az" {
  value = data.aws_availability_zones.available
}

output "current" {
  value = data.aws_region.current
}





/*

#Deploy the private subnets inside the VPC and the availability zones
resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = {
    Name      = each.key
    Terraform = "true"
  }
}

*/