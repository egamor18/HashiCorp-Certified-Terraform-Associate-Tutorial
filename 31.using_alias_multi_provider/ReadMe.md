---

# Terraform AWS Multi-Provider and Alias Example

This example demonstrates how to use **multiple AWS providers** with **aliases** in Terraform to deploy resources across different AWS regions within a single configuration.

---

## 🧩 What Are Provider Aliases?

In Terraform, a **provider** defines how Terraform connects to a specific cloud or service — for example, AWS, Azure, or GCP.

By default, you can define one AWS provider block, which determines:

* The AWS region Terraform will deploy to
* The credentials and configuration it uses

However, in many real-world scenarios, you may need to deploy infrastructure in **multiple regions** (e.g., for redundancy or latency optimization).

This is where **provider aliases** come in.

An **alias** lets you create **additional provider configurations** for the same service but with different settings (e.g., different AWS regions or credentials). You can then tell Terraform which provider alias to use for each resource.

---

## ⚙️ Provider Configuration

In this example, we define four AWS providers — one default and three aliased — each pointing to a different region:

```hcl
provider "aws" {
  region = "us-east-1" # Default provider (no alias)
}

provider "aws" {
  alias  = "east2"
  region = "us-east-2"
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

provider "aws" {
  alias  = "west1"
  region = "us-west-1"
}
```

* The **default provider** (no alias) is automatically used by resources that do not specify a `provider` argument.
* The **aliased providers** must be explicitly referenced using the syntax:

  ```hcl
  provider = aws.<alias>
  ```

---

## 🪣 Example: Creating S3 Buckets in Multiple Regions

We’ll create S3 buckets in several AWS regions using the providers defined above.

```hcl
# Default region (us-east-1)
resource "aws_s3_bucket" "default_region" {
  bucket = "my-tf-example-bucket-gamor-default-region"
}

# us-east-2 region
resource "aws_s3_bucket" "east2" {
  provider = aws.east2
  bucket   = "my-tf-example-bucket-gamor-us-east-2-region"
}

# us-west-1 region
resource "aws_s3_bucket" "west1" {
  provider = aws.west1
  bucket   = "my-tf-example-bucket-gamor-us-west-1-region"
}
```

---

## 🧠 How It Works

* Resources **without** a `provider` argument use the **default** AWS provider (`us-east-1`).
* Resources **with** a `provider = aws.<alias>` argument use the **specified region**.
* This setup allows a single Terraform configuration to manage infrastructure across **multiple regions**.

---

## 🧰 Commands to Run

Initialize Terraform and download provider plugins:

```bash
terraform init
```

Preview your deployment:

```bash
terraform plan
```

Apply the configuration to create the S3 buckets:

```bash
terraform apply
```

---

## ✅ Key Takeaways

* Provider **aliases** let you define multiple configurations for the same provider.
* You can use aliases to manage infrastructure **across multiple AWS regions** or **accounts**.
* Always specify `provider = aws.<alias>` when using an aliased provider.
* The **default provider** is used automatically when no alias is specified.

---
