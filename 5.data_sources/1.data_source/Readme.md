
---

# 🧠 Terraform Data Sources — Demo with AWS AMI

## 📘 Introduction

In Terraform, **data sources** allow you to **fetch and use information defined outside your configuration** — such as existing resources, public data, or provider-managed metadata — without creating new infrastructure.

They are read-only views into data managed elsewhere, enabling dynamic and reusable configurations.

Common use cases include:

* Retrieving the latest Amazon Machine Image (AMI)
* Querying VPC or subnet IDs that already exist
* Fetching secrets from Vault or AWS Secrets Manager

---

## 🧩 Demo: Fetching the Latest Ubuntu AMI

### 🔹 Code Overview

The following Terraform configuration demonstrates how to use a **data source** to dynamically retrieve the latest Ubuntu 22.04 AMI from AWS and use it to launch an EC2 instance.

```hcl
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Fetch the latest Ubuntu 22.04 image from Canonical
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Create an EC2 instance using the AMI fetched above
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
}

# Output the AMI ID for verification
output "ubuntu_ami" {
  value = data.aws_ami.ubuntu.id
}
```

---

## ⚙️ How It Works

1. **Provider Configuration**
   The AWS provider is configured to operate in the `us-east-1` region.

2. **Data Source Block (`data "aws_ami" "ubuntu"`)**

   * The block queries AWS for AMIs owned by Canonical (`owners = ["099720109477"]`).
   * It filters for Ubuntu 22.04 images using a name pattern.
   * It returns the **most recent** match (latest version).

3. **Resource Creation (`aws_instance`)**
   The EC2 instance uses the AMI ID from the data source instead of a hardcoded value:

   ```hcl
   ami = data.aws_ami.ubuntu.id
   ```

4. **Output**
   Displays the AMI ID Terraform retrieved — useful for debugging or logging.

---

## 🧪 Running the Demo

```bash
terraform init
terraform apply
```

After applying, you’ll see an output similar to:

```
ubuntu_ami = "ami-0a23a9827c6a8c49a"
```

---

## ✅ Key Takeaways

* **Data sources** are read-only — they do not create or modify infrastructure.
* They help make Terraform configurations **dynamic**, **reusable**, and **cloud-agnostic**.
* They are ideal for retrieving **existing infrastructure information** such as AMIs, VPCs, and subnet IDs.

---
