### DynamoDB State Locking

When you use **S3 as a backend** for Terraform state, the **state file lives remotely**. This is great for collaboration, but it introduces a **potential problem**:

### The Problem

If **two people or processes run `terraform apply` at the same time**, they could both read the same state, make changes, and write back simultaneously.
This can **corrupt the state file** and lead to unpredictable infrastructure changes.

---

### The Solution: DynamoDB State Locking

Terraform supports **state locking** using an **AWS DynamoDB table**:

1. Terraform creates a **lock entry** in the DynamoDB table whenever someone runs `terraform plan` or `terraform apply`.
2. If another user tries to run Terraform at the same time, Terraform **waits until the lock is released**.
3. Once the operation completes, Terraform removes the lock from DynamoDB.

This ensures **only one Terraform operation modifies the state at a time**, preventing conflicts and corruption.

---

### Example Backend with DynamoDB Locking

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-s3-backend-authentication-demo-gamor"
    key            = "terraform/state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"   # DynamoDB table used for state locking
    encrypt        = true                # Optional: encrypt state at rest
  }
}
```

* `dynamodb_table`: Name of the DynamoDB table used for locking.
* Terraform will automatically **create, acquire, and release locks** in this table.

---

### How to Create the DynamoDB Table

* **Via AWS Console**:
  * Table name: `terraform-locks`
  * Primary key: `LockID` (String)
>Terraform uses the DynamoDB table as a state lock store. Every lock entry in the table must have a primary key called **LockID (case-sensitive)**.
* **Via Terraform**:

```hcl
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```

✅ **Note:** You can choose any table name, but the primary key should be exactly **`LockID`**.

---

✅ **In short:**

> DynamoDB state locking ensures **only one person or process modifies Terraform state at a time**, protecting against accidental corruption in collaborative environments.

---
