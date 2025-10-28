
---

# 🌍 Terraform Demo — Using AWS Region and Availability Zone Data Sources

## 📘 Introduction

This Terraform demo shows how to use **AWS data sources** to dynamically retrieve environment-specific information — specifically:

* The **current AWS region**, and
* The **available availability zones (AZs)** in that region.

It then uses this information to **configure a VPC** and optionally (in the commented-out section) deploy subnets across the available zones.

By using **data sources**, we make the configuration **dynamic**, **portable**, and **reusable** — removing the need to hardcode region- or zone-specific details.

---

## 🧩 Code Overview

```hcl
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Get the current AWS region
data "aws_region" "current" {}

# Fetch all availability zones in that region
data "aws_availability_zones" "az" {}

# Define a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = var.vpc_name
    Environment = "demo_environment"
    Terraform   = "true"
    Region      = data.aws_region.current.name
  }
}

# (Optional) Deploy private subnets in each availability zone
# resource "aws_subnet" "private_subnets" {
#   for_each          = var.private_subnets
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
#   availability_zone = tolist(data.aws_availability_zones.az.names)[each.value]
#   tags = {
#     Name      = each.key
#     Terraform = "true"
#   }
# }

# Outputs for verification
output "az" {
  value = data.aws_availability_zones.az
}

output "current" {
  value = data.aws_region.current
}
```

---

## ⚙️ How It Works

1. **Provider Block**
   Configures the AWS provider to work in the `us-east-1` region.

2. **`data "aws_region"`**
   Retrieves details about the **currently configured AWS region**, such as its name and description.

   * Example output:

     ```hcl
     current = {
       "name" = "us-east-1"
       "description" = "US East (N. Virginia)"
     }
     ```

3. **`data "aws_availability_zones"`**
   Fetches all **availability zones** within that region.

   * Example output:

     ```
     az = {
       names = ["us-east-1a", "us-east-1b", "us-east-1c"]
     }
     ```

4. **VPC Resource**
   Creates a VPC with a CIDR block defined by `var.vpc_cidr`, tagging it with:

   * A custom name (`var.vpc_name`)
   * Environment metadata
   * The dynamically retrieved region name from the data source.

5. **Outputs**
   Prints both the region and AZ data to the terminal after `terraform apply`, verifying that Terraform dynamically queried AWS for these details.

---

## 🚀 How to Run the Demo

1. **Initialize Terraform**

   ```bash
   terraform init
   ```

2. **Preview the Plan**

   ```bash
   terraform plan
   ```

3. **Apply the Configuration**

   ```bash
   terraform apply
   ```

4. **Check Outputs**

   ```bash
   terraform output
   ```

---

## 🧠 Key Takeaways

* **Data sources** make Terraform dynamic — you don’t need to hardcode environment data.
* `aws_region` and `aws_availability_zones` are great for making your network setup portable across regions.
* Outputs help validate what Terraform fetched and can be used in other modules or scripts.
* You can extend this configuration by **uncommenting the subnet resource** block to create private subnets dynamically across all AZs.

---
