---

## 🧩 Understanding Module Outputs in Terraform

When working with **modules** in Terraform, you often need to **reference values** (like IDs or ARNs) from inside a module in your **parent/root module**.
To make this possible, you must explicitly **declare output values** inside the module.

---

### **Step 1: Define Outputs in the Module**

📄 **`modules/my_s3_bucket_module/output.tf`**

```hcl
output "bucket_id" {
  description = "The ID of the bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.this.arn
}
```

✅ These outputs make `bucket_id` and `bucket_arn` available to any parent module that calls this module.

---

### **Step 2: Reference Module Outputs in the Parent**

📄 **`output.tf` (in the parent module)**

```hcl
output "bucket_id" {
  value = module.storage.bucket_id
}
```

💡 Here, `module.storage` refers to the module block (for example):

```hcl
module "storage" {
  source = "./modules/my_s3_bucket_module"
}
```

---

### **Step 3: Run Terraform Commands**

Run the following from the **parent module directory**:

```bash
terraform init
terraform apply
```

✅ Terraform will:

* Initialize the module.
* Create the S3 bucket.
* Display the **bucket ID** (and any other outputs).

You can verify the output in your terminal — Terraform prints values from your module outputs.

---

### **Step 4: Removing Outputs**

Now, if you **comment out** or **remove** the `output "bucket_id"` block inside the module and re-run:

```bash
terraform init
terraform apply
```

❌ Terraform will throw an **error**, because the parent module still references `module.storage.bucket_id`, but that value is no longer being exported from the module.

---

### **🎓 Lesson Learned**

When defining a module:

* Any value you want to **reference externally (from the parent)** must be **declared inside an output block** of the module.
* Without that `output`, the value is **not accessible** to the parent.

Think of Terraform’s `output` block as similar to:

* `return` in a function (in programming languages), or
* `export` in shell scripting.

It’s how a module **exposes** data for use elsewhere.


also:
🧩 Key Principle

Any value you define in a child module’s output block becomes directly accessible in the parent module — simply by referencing module.<module_name>.<output_name>.
---
