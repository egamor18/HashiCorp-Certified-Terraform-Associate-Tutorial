
---

# Using HashiCorp Vault with Terraform to Manage AWS Credentials

This guide explains how to configure Terraform to retrieve AWS credentials securely from HashiCorp Vault and use them to provision AWS resources.

---

## **Prerequisites**

1. **HashiCorp Vault installed** and running locally or accessible via network.

   * Ensure Vault is **initialized and unsealed**.
   * You have a **token with access to `secret/aws_creds`**.
2. **Terraform CLI (v1.2.0+) installed**.
3. **AWS account** with IAM permissions to create resources in your target region.
4. **Local environment variable** for Vault token:

   ```bash
   export VAULT_TOKEN="your_vault_token_here"
   ```
5. Vault KV secrets stored in version 2 at `secret/aws_creds`:

   ```
   secret/data/aws_creds
   ├─ access_key: YOUR_AWS_ACCESS_KEY
   └─ secret_key: YOUR_AWS_SECRET_KEY
   ```

---

## **Terraform Configuration Overview**

```hcl
provider "vault" {
  address = "http://127.0.0.1:8200"
  # token is provided through the VAULT_TOKEN environment variable
}

data "vault_kv_secret_v2" "aws_creds" {
  mount = "secret"
  name  = "aws_creds"
}

provider "aws" {
  region     = "us-east-1"
  access_key = data.vault_kv_secret_v2.aws_creds.data["access_key"]
  secret_key = data.vault_kv_secret_v2.aws_creds.data["secret_key"]

  default_tags {
    tags = {
      Environment = local.environment
      Owner       = "Eric"
      Provisioned = "Terraform"
    }
  }
}
```

### Key Points:

* **Vault Provider**: Connects Terraform to Vault (`http://127.0.0.1:8200` in this example).
* **Vault KV Data Source**: Retrieves AWS credentials from Vault (`secret/aws_creds`).
* **AWS Provider**: Uses the credentials fetched dynamically from Vault for authentication.
* **Tags**: Applies default tags to all AWS resources.

---

## **Step-by-Step Usage**

1. **Set Vault token in your environment**:

   ```bash
   export VAULT_TOKEN="your_vault_token_here"
   ```

2. **Initialize Terraform**:

   ```bash
   terraform init
   ```

   * Downloads providers and initializes the working directory.

3. **Validate configuration**:

   ```bash
   terraform validate
   ```

   * Ensures the syntax and provider references are correct.

4. **Plan the infrastructure**:

   ```bash
   terraform plan
   ```

   * Shows what resources will be created or modified.
   * AWS credentials will be fetched from Vault during planning.

5. **Apply the configuration**:

   ```bash
   terraform apply
   ```

   * Provisions the infrastructure using AWS credentials stored in Vault.
   * Confirm the prompt with `yes`.

6. **Destroy resources (if needed)**:

   ```bash
   terraform destroy
   ```

   * Cleans up all resources managed by this Terraform configuration.

---

## **Best Practices**

* **Never hardcode secrets** in Terraform files; always fetch from Vault or environment variables.
* **Use environment variables for Vault token** to avoid exposing it in code.
* **Store sensitive secrets in Vault with proper policies** to control access.
* **Version control only the Terraform code, not the secrets**.

---


