s
---

# Terraform Default Variables Demo

## 📘 Overview

This example demonstrates how **default variables** work in Terraform.
Default variables provide fallback values for inputs so that your configuration can run **without requiring manual input** every time.

The code below launches an **AWS EC2 instance** in the `us-east-1` region, using a default instance type defined in the variable block.

---

## 🧩 Code Breakdown

### 1. **AWS Provider**

```hcl
provider "aws" {
  region = "us-east-1"
}
```

Configures the AWS provider to use the **US East (N. Virginia)** region.

---

### 2. **EC2 Instance Resource**

```hcl
resource "aws_instance" "example" {
  ami           = "ami-052064a798f08f0d3"
  instance_type = var.instance_type
}
```

Creates an **EC2 instance** using a fixed Amazon Machine Image (AMI) and a variable for the instance type.

---

### 3. **Default Variable**

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```

This defines a variable called `instance_type` with a **default value of `t2.micro`**.
If you run Terraform without providing a value for this variable, it automatically uses the default.

---

## 🧪 Demo Steps

### **Step 1: Initialize Terraform**

```bash
terraform init
```

This downloads the necessary provider plugins (in this case, AWS).

---

### **Step 2: Run Terraform Plan**

```bash
terraform plan
```

You’ll see that Terraform plans to create a `t2.micro` instance because that’s the default value.

---

### **Step 3: Apply the Configuration**

```bash
terraform apply
```

Terraform will create the instance using the **default `t2.micro`** type.

---

### **Step 4 (Optional): Override the Default**

If you want to change the instance type without editing the `.tf` file, you can pass a new value:

```bash
terraform apply -var "instance_type=t3.micro"
```

Terraform now overrides the default and launches a `t3.micro` instance instead.

---

### **Step 5: Clean Up**

When done, destroy the created resources:

```bash
terraform destroy
```

---

## ✅ Key Takeaways

* **Default variables** make your configurations flexible and reusable.
* They allow Terraform to run even if a variable isn’t manually provided.
* You can override defaults using:

  * `-var` flag on the command line
  * Variable files (`.tfvars`)
  * Environment variables (`TF_VAR_...`)
**NOTE** unset the environmental variable with:
```bash
unset TF_VAR_instance_type
```

---
