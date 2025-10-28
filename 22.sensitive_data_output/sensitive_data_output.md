## SECURITY OF TERRAFORM STATE 

# 🗂️ Best Practices

Terraform’s **state file (`terraform.tfstate`)** keeps track of all the resources Terraform manages and their real-world attributes.
Because it can contain secrets and identifiers (like ARNs, passwords, or keys), it’s essential to protect it properly.

---

## 🔐 1. Treat State as Sensitive Data

Terraform state often contains plain-text values such as:

* Database credentials
* Access tokens or API keys
* Resource ARNs (which include your AWS account number)

> ⚠️ Always treat your Terraform state file as **confidential data**, just like environment secrets or SSH keys.

---

## 🧱 2. Encrypt the State Backend

Instead of storing the state locally, store it remotely in a **secure, encrypted backend** like:

* **Amazon S3**
* **Google Cloud Storage (GCS)**
* **Azure Blob Storage**

These backends ensure your data is encrypted:

* **In transit** via TLS/HTTPS
* **At rest** via AES-256 or KMS-managed encryption

### ✅ Example — Encrypted S3 Backend

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-s3-backend-authentication-demo-gamor"
    key            = "terraform/state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks" # For state locking
    encrypt        = true              # Encrypts state at rest
  }
}
```

The line `encrypt = true` ensures your state file is encrypted **while stored** in S3.

---

## 🧍‍♂️ 3. Control Access to the State File

Limit who can access the Terraform backend.
For example, if using an S3 bucket, only allow:

* The CI/CD system that performs deployments
* A few trusted administrators or DevOps engineers

### ✅ Example — Restricted IAM Policy Snippet

```json
{
  "Effect": "Allow",
  "Action": [
    "s3:GetObject",
    "s3:PutObject",
    "s3:DeleteObject",
    "dynamodb:*"
  ],
  "Resource": [
    "arn:aws:s3:::terraform-state-demo/*",
    "arn:aws:dynamodb:us-east-1:123456789012:table/terraform-locks"
  ]
}
```

This ensures only specific users or services can modify or view the state.

---

## 🧩 4. Mark Sensitive Variables and Outputs: Suppress outputs of sensitive values in the CLI

Terraform allows you to **hide sensitive information** from logs and command-line output using the `sensitive = true` argument.

This helps prevent secrets or identifiers — such as AWS account numbers in ARNs — from being displayed accidentally.

---

### ✅ Example — Sensitive Outputs

```hcl
# OUTPUT
##############################################
output "workspace_name" {
  value = terraform.workspace
}

output "aws_region" {
  value = local.region
}

output "instance_id" {
  value = aws_instance.web.id
}

# Output ARN which contains account number
output "instance_arn" {
  value = aws_instance.web.arn
  #sensitive = true
}

output "instance_arn_sensitive" {
  value     = aws_instance.web.arn
  sensitive = true
}
```

This configuration demonstrates how to **make the instance ARN sensitive**, thereby **hiding your AWS account number** and other identifiers from the output.

When you run `terraform output`, the `instance_arn_sensitive` value will display as:

```
instance_arn_sensitive = (sensitive value)
```
**Note** : Even though items are marked as sensitive within the Terraform configuration, they are stored within
the Terraform state file.

> 💡 **Tip:**
> Setting `sensitive = true` only hides the value in the CLI output — it does **not encrypt** it in the state file.
> That’s why using an **encrypted backend (like S3 with `encrypt = true`)** is still essential.

---

## 🧠 Summary

| Best Practice                | Description                                                            |
| ---------------------------- | ---------------------------------------------------------------------- |
| **Treat State as Sensitive** | State files may contain secrets or ARNs; protect them.                 |
| **Encrypt the Backend**      | Use encrypted remote storage (S3, GCS, Azure).                         |
| **Restrict Access**          | Grant access only to trusted users or CI/CD pipelines.                 |
| **Use `sensitive = true`**   | Prevent secret values and account numbers from showing in CLI outputs. |

---
