# Terraform AWS S3 Bucket with Randomized Name

This Terraform configuration creates an Amazon S3 bucket with a random suffix to ensure uniqueness.  
It also configures ownership controls, public access settings, and an ACL to make the bucket publicly readable.

## 🧠 What It Does

- Configures the AWS provider for the `us-east-1` region.
- Generates a random 16-byte hex ID using the `random_id` resource.
- Creates an S3 bucket named `my-tf-example-bucket-gamor-<random_hex>`.
- Applies ownership controls (`BucketOwnerPreferred`).
- Configures the public access block settings (all disabled for demo purposes).
- Grants a `public-read` ACL to allow public access to bucket contents.

## 🪜 How to Use

1. **Initialize the working directory**
   ```bash
   terraform init
