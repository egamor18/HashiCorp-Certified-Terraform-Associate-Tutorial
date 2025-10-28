## TERRAFORM GET

---

## 🧩 What `terraform get` Does

The **`terraform get`** command is used to **download and update modules** that are referenced in your Terraform configuration files.

It looks at your configuration (the `.tf` files) and pulls down any **external** or **local modules** so Terraform can use them.

---

## ⚙️ Example Project Structure

Let’s say you have this folder structure:

```
project/
├── main.tf
└── modules/
    └── s3_bucket/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

### **main.tf**

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Using a local module
module "storage" {
  source = "./modules/s3_bucket"

  bucket_name       = "terraform-get-demo-bucket"
  enable_versioning = true
}
```

---

## 🧠 Step-by-Step Demo

### 🪜 Step 1: Initialize Terraform

```bash
terraform init
```

✅ This sets up the working directory and downloads the provider plugins.
If your configuration already references modules, `terraform init` **automatically calls `terraform get`** internally.

---

### 🪜 Step 2: Run `terraform get`

```bash
terraform get
```

✅ Terraform will:

* Download local or remote modules
* Display output like:

  ```
  - module.storage
    Getting source "./modules/s3_bucket"
  ```

If the module was already downloaded, it may say:

```
- module.storage
  Already up to date.
```

---

### 🪜 Step 3: Update a Module (Optional)

If you change the source of a module (for example, a Git URL or local path) and want to re-download it:

```bash
terraform get -update
```

✅ This forces Terraform to **refresh all module sources**, even if they already exist locally.

---

## 🧾 Key Notes

| Command                    | Description                                                     |
| -------------------------- | --------------------------------------------------------------- |
| `terraform get`            | Downloads modules for the first time                            |
| `terraform get -update`    | Forces a re-download of all modules                             |
| `terraform init`           | Also gets modules, but primarily used to initialize a workspace |
| `terraform plan` / `apply` | Will fail if `terraform get` hasn’t downloaded modules yet      |

---

## 🧩 Real-World Use Case

When you clone someone else’s Terraform project that uses modules (local or remote), you’ll typically do:

```bash
terraform init
terraform get
terraform plan
```

This ensures all modules are fetched and your configuration is ready to run.

---

✅ **Summary**

* `terraform get` = Downloads or updates Terraform modules.
* Usually run **after adding or changing module sources**.
* Use `-update` to force refresh.
* Automatically invoked by `terraform init`, but can be used manually when working on modules.

---
