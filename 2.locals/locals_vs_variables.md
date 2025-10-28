
---

# 🌱 Locals vs. Variables — Understanding Their Roles

Both **`locals`** and **`variables`** store values in Terraform, but they serve **different purposes** and have **different scopes**.

---

## 🧩 1. Variables (`variable` block in *variables.tf*)

### 🔹 What They Are

These are **input variables** — values that come **from outside** the configuration (user, CLI, or CI/CD pipeline).

They’re meant to be **configurable** — like parameters for your Terraform project.

### 🧾 Example

**`variables.tf`**

```hcl
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}
```

You can override these when running Terraform:

```bash
terraform apply -var="environment=prod" -var="region=eu-west-1"
```

Or using a `terraform.tfvars` file.

✅ **Purpose:** Control Terraform configuration from the outside (user, automation, etc.)

---

## 🧩 2. Locals (`locals` block)

### 🔹 What They Are

These are **internal constants or computed values** — used **inside** the Terraform code.
They’re **not inputs**, and **users cannot override them**.

They’re like helper variables — used to:

* Simplify repeated logic
* Compute values from other variables
* Create consistent naming conventions

### 🧾 Example

```hcl
locals {
  app_name    = "backend"
  environment = var.environment
  bucket_name = "${local.app_name}-${local.environment}-bucket"
}
```

You use them in your resources like this:

```hcl
resource "aws_s3_bucket" "main" {
  bucket = local.bucket_name
}
```

✅ **Purpose:** Compute and reuse values *within* Terraform configuration.

---

## 🧠 Key Difference — Who Controls Them?

| Feature                | `variable`                                 | `local`                             |
| ---------------------- | ------------------------------------------ | ----------------------------------- |
| **Defined in**         | `variables.tf` (usually)                   | `locals.tf` or any `.tf` file       |
| **Set by**             | User, tfvars file, environment, CLI        | Terraform code itself               |
| **Can be overridden?** | ✅ Yes                                      | ❌ No                                |
| **Typical usage**      | User input like region, env, instance type | Computed names, tags, derived logic |
| **Scope**              | “Global” input for module                  | Local to configuration or module    |
| **Evaluation**         | At runtime from user input                 | Static at plan time from code       |

---

## 🧰 Example: Both Working Together

```hcl
variable "environment" {
  description = "Deployment environment"
  default     = "dev"
}

locals {
  app_name    = "inventory"
  bucket_name = "${local.app_name}-${var.environment}-bucket"
}

resource "aws_s3_bucket" "main" {
  bucket = local.bucket_name
}
```

### 💬 Explanation:

* The user controls `environment` (`dev`, `stage`, `prod`).
* Terraform computes the full `bucket_name` using a local.
* The local is **dependent on the variable**, but **not user-editable**.

---

## 💡 Analogy

Think of it like **function parameters vs. internal constants**:

| Concept                                | In Programming                 | In Terraform |
| -------------------------------------- | ------------------------------ | ------------ |
| **Function parameter**                 | Value you pass into a function | `variable`   |
| **Local variable inside the function** | Used to compute internal logic | `local`      |

---

## ✅ Summary

| Category              | `variable`                         | `local`                      |
| --------------------- | ---------------------------------- | ---------------------------- |
| **Purpose**           | External inputs                    | Internal computed values     |
| **Editable by user?** | ✅ Yes                              | ❌ No                         |
| **Best defined in**   | `variables.tf`                     | `locals.tf`                  |
| **Use case**          | Environment, region, resource size | Naming, tags, computed logic |
| **Reference syntax**  | `var.<name>`                       | `local.<name>`               |

---
