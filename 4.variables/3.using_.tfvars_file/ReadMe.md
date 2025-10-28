There are **three main ways** to provide variable values in Terraform:
1️⃣ via **environment variables** (`TF_VAR_name`)
2️⃣ via **command-line flags** (`-var`)
3️⃣ via **.tfvars files** (like `terraform.tfvars` or `*.auto.tfvars`)

---

## 📘 Using `terraform.tfvars`

### 🧩 Example file: `terraform.tfvars`

Create a file named **`terraform.tfvars`** in your project directory:

```hcl
instance_type = "t3.micro"
region        = "eu-north-1"
instance_name = "demo-server"
```

---

### 🏗️ Example variable definitions

In your `variables.tf`:

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the instance"
  type        = string
}
```

---

### ⚙️ Terraform automatically loads this file

Terraform automatically looks for:

* `terraform.tfvars`
* `*.auto.tfvars` (like `dev.auto.tfvars`, `prod.auto.tfvars`)

You don’t have to pass any flag — just run:

```bash
terraform plan
```

✅ Terraform will automatically load the values and apply them.

---

### 💡 Optionally specify a custom file

If you want to use a different name:

```bash
terraform plan -var-file="custom.tfvars"
```

---

### 🧠 Summary

| Method            | File Name          | Automatically Loaded?  | Example                                     |
| ----------------- | ------------------ | ---------------------- | ------------------------------------------- |
| Default vars file | `terraform.tfvars` | ✅ Yes                  | `instance_type = "t3.micro"`                |
| Auto-loaded vars  | `dev.auto.tfvars`  | ✅ Yes                  | `region = "eu-north-1"`                     |
| Custom vars       | any name           | ❌ No (use `-var-file`) | `terraform plan -var-file="staging.tfvars"` |

---

