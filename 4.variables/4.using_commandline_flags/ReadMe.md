

### How to set Terraform variables directly from the command line

---

## 🧩 Step 1: Define variables

In your `variables.tf`:

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_name" {
  description = "Tag name for the EC2 instance"
  type        = string
}
```

---

## 🏗️ Step 2: Use them in your configuration

Example `main.tf`:

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
```

---

## 🚀 Step 3: Pass variables using the CLI
First initialize the workspace:

```bash
terraform init
```

You can pass values at runtime like this:

```bash
terraform plan -var="instance_type=t3.micro" -var="instance_name=tf-passing-variables" -out=myplan
```

or for apply:

```bash
terraform apply myplan
```

---

## 🧠 Notes

* You can pass multiple `-var` flags at once.
* CLI flags **override** values from `.tfvars` files and **environment variables**.
* Useful for **quick tests** or **temporary overrides** (e.g., trying different instance types).

---
# NOTE: WHEN DESTROYING THE WORKSPACE, YOU WILL BE PROMPTED TO RE-ENTER THE VARIABLES AGAIN.

This is **because Terraform does not automatically remember variable values** you passed via the command line or environment unless you save them in a file.

---

### 🧩 Why You’re Asked Again

When you first ran something like:

```bash
terraform apply -var="instance_type=t3.micro" -var="instance_name=tf-passing-variables"
```

Terraform used those values to create your resources.
But it **did not save** them permanently in state or configuration.
So when you later run:

```bash
terraform destroy
```

Terraform checks your configuration and sees that `instance_type` and `instance_name` are *required variables* but doesn’t know their values — hence it prompts you to enter them again.

---

