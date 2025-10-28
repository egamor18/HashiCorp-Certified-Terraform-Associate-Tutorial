### TERRAFORM MODULES
---

## 🌍 What is a Terraform module?

A **module** is simply a **container for Terraform code** —
like a reusable building block made up of **resources**, **variables**, and **outputs**.

You can think of it as a **function** in programming:

> A module takes inputs (variables), does something (creates resources), and returns outputs.

---

## 🧩 1. Types of modules

### a) **Root module**

* This is your **main Terraform configuration** — where you run `terraform apply`.
* All `.tf` files in the same working directory make up the root module.

Example:

```
main.tf
variables.tf
outputs.tf
```

---

### b) **Child module**

* A **reusable module** that can be called from another module (usually the root).
* It can be stored:

  * Locally (`./modules/…`)
  * In a Git repo
  * In a Terraform Registry (e.g. `terraform-aws-modules/vpc/aws`)

---

## 🏗️ 2. Structure of a simple module

Let’s make a small example module that creates a local file.

### Folder structure:

```
project/
├── main.tf
├── variables.tf
├── modules/
│   └── local_file_module/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

---

### Inside the module: `modules/local_file_module/main.tf`

```hcl
resource "local_file" "this" {
  content  = var.content
  filename = "${path.module}/${var.name}.txt"
}
```

### Module variables: `modules/local_file_module/variables.tf`

```hcl
variable "name" {
  type = string
}

variable "content" {
  type = string
}
```

### Module outputs: `modules/local_file_module/outputs.tf`

```hcl
output "file_path" {
  value = local_file.this.filename
}
```

---

### In the root module: `main.tf`

```hcl
module "fruit_file" {
  source  = "./modules/local_file_module"
  name    = "apple"
  content = "This is an apple file."
}

output "apple_file_path" {
  value = module.fruit_file.file_path
}
```

---

### 🧠 How it works

* `source` tells Terraform **where the module lives**
* Inputs (`name`, `content`) are passed as variables
* The module creates a local file and exposes an output
* The root module can reference outputs like `module.fruit_file.file_path`

---

## 🌐 3. Calling remote modules

You can use modules from:

* Terraform Registry
* GitHub
* Local paths

### Example from Terraform Registry:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
}
```

---

## 🧠 4. Module best practices

| Rule                                               | Why                                     |
| -------------------------------------------------- | --------------------------------------- |
| Keep modules small and focused                     | Easier to test and reuse                |
| Use variables and outputs clearly                  | Encapsulate internal logic              |
| Never hardcode region, credentials, or account IDs | Keep modules environment-agnostic       |
| Version control your modules                       | Enables consistent reproducible infra   |
| Prefer `for_each` over `count` for named resources | Prevents re-creation when order changes |

---

## 📦 5. Analogy

| Concept       | In programming      | In Terraform                     |
| ------------- | ------------------- | -------------------------------- |
| Function      | Defines logic       | Module (defines infra)           |
| Arguments     | Function parameters | Module variables                 |
| Return value  | Function output     | Module outputs                   |
| Function call | Call function()     | `module "name" { source = ... }` |

---

## ⚙️ 6. Key commands

| Command            | Purpose                               |
| ------------------ | ------------------------------------- |
| `terraform init`   | Downloads providers and modules       |
| `terraform get`    | Updates local copies of child modules |
| `terraform apply`  | Runs with all modules included        |
| `terraform output` | Shows module outputs                  |

---
