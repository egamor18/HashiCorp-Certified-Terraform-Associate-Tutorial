
---

# Terraform Environment Variables Demo

## 📘 Overview

This example demonstrates how to use **Terraform environment variables** to provide values to input variables without directly modifying the code.
The configuration deploys a simple **AWS EC2 instance** in the `us-east-1` region.

---

## 🧩 Code Breakdown

### 1. **AWS Provider**

```hcl
provider "aws" {
  region = "us-east-1"
}
```

This block configures Terraform to use the AWS provider in the **US East (N. Virginia)** region.

---

### 2. **EC2 Instance Resource**

```hcl
resource "aws_instance" "example" {
  ami           = "ami-052064a798f08f0d3"
  instance_type = var.instance_type
}
```

This creates an **EC2 instance** using a specific Amazon Machine Image (AMI) and a variable-defined instance type.

---

### 3. **Input Variable**

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```

The instance type is configurable via the variable `instance_type`.
By default, Terraform will create a **t2.micro** instance.

---

## 🌍 Using Environment Variables

Terraform allows you to override variable values using environment variables without modifying your `.tf` files.

To do this, prefix the variable name with `TF_VAR_` and export it in your terminal.

### Example:

```bash
export TF_VAR_instance_type="t3.micro"
terraform apply
```

Terraform will now use `t3.micro` instead of the default `t2.micro`.

**Note** Environmental variables overrides default variables.  This can be seen the code: The default instance type is:t2.micro
---

## 🧪 Steps to Run

1. **Initialize Terraform**

   ```bash
   terraform init
   ```
2. **(Optional)** Set an environment variable

   ```bash
   export TF_VAR_instance_type="t3.micro"
   ```
3. **Plan the deployment**

   ```bash
   terraform plan
   ```
4. **Apply the configuration**

   ```bash
   terraform apply
   ```
5. **Clean up**

   ```bash
   terraform destroy
   ```

---

## ✅ Key Takeaways

* Environment variables offer a **secure and flexible** way to pass input values.
* This is especially useful in **CI/CD pipelines** and **multi-environment setups**.
* Terraform variable precedence:
  **Environment variables** > **Command line flags** > **Variable files** > **Defaults**

---
