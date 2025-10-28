
---

## 🧭 OVERVIEW

**Goal:**
Use **HashiCorp Vault** as a **secure secrets manager** and have **Terraform** dynamically read secrets (like AWS keys, DB passwords, etc.) from Vault instead of hard-coding them.

---

## 🧩 1️⃣ INSTALL VAULT

### 🖥️ On Ubuntu / Linux

```bash
# Add HashiCorp’s official repository
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

# Install Vault
sudo apt update && sudo apt install vault -y
```

### ✅ Verify installation

```bash
vault --version
```

---

## 🚀 2️⃣ START A DEVELOPMENT VAULT SERVER (for testing)

```bash
vault server -dev
```

* Vault will start in **dev mode**, running locally (by default on port `8200`).
* It will print a **root token** (e.g., `root` or random string). Copy that!

### Set environment variables

```bash
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='ROOT-TOKEN'
```

You can verify Vault is reachable:

```bash
vault status
```

---

## 🔐 3️⃣ STORE SECRETS IN VAULT

### Enable key/value secrets engine

```bash
vault secrets enable -path=secret kv
```

### Store a secret

```bash
vault kv put secret/aws_creds access_key="AWS ACCESS KEY" secret_key="AWS SECRET KEY"
```

### Read it back

```bash
vault kv get secret/aws_creds
```

---

## 🧰 4️⃣ CONFIGURE TERRAFORM TO USE VAULT

### Step 1: Add the Vault provider

**terraform {
required_providers {
vault = {
source  = "hashicorp/vault"
version = "~> 4.3"
}
}
}**

### Step 2: Configure provider (in `main.tf`)

```hcl
provider "vault" {
  address = "http://127.0.0.1:8200"
}
```

*(In production, do **not** hard-code the token — use environment variables or Vault authentication methods like AWS IAM, GitHub, or AppRole.)*

---

## 🧩 5️⃣ READ SECRETS FROM VAULT IN TERRAFORM

Example — use secrets to create an AWS provider.

```hcl
data "vault_kv_secret_v2" "aws_creds" {
  mount = "secret"
  name  = "aws_creds"
}

provider "aws" {
  region     = "us-east-1"
  access_key = data.vault_kv_secret_v2.aws_creds.data["access_key"]
  secret_key = data.vault_kv_secret_v2.aws_creds.data["secret_key"]
}
```

✅ Now your AWS credentials are **fetched dynamically from Vault** — no secrets in `.tf` files or Git!

---

## 🧱 6️⃣ SAMPLE WORKFLOW

```bash
terraform init
terraform plan
terraform apply
```

Terraform will automatically pull secrets from Vault during execution.

---

## 🧰 7️⃣ PRODUCTION RECOMMENDATIONS

* **Never** use `-dev` mode in production.
* Enable **TLS** for Vault (HTTPS).
* Use **AppRole**, **AWS IAM**, or **OIDC** for Terraform authentication.
* Control access with **Vault policies**.
* Rotate tokens and secrets regularly.
* Store the **Terraform state** securely (e.g., S3 + DynamoDB + encryption).

---

## 📦 8️⃣ OPTIONAL: EXAMPLE DIRECTORY STRUCTURE

```
vault-demo/
├── main.tf
├── variables.tf
├── outputs.tf
└── backend.tf
```

---

## ✅ SUMMARY

| Step | Purpose                  | Key Command                              |
| ---- | ------------------------ | ---------------------------------------- |
| 1    | Install Vault            | `sudo apt install vault`                 |
| 2    | Start Dev Server         | `vault server -dev`                      |
| 3    | Store Secret             | `vault kv put secret/aws access_key=...` |
| 4    | Configure Provider       | `provider "vault" { ... }`               |
| 5    | Read Secret in Terraform | `data "vault_kv_secret_v2" ...`          |

---
