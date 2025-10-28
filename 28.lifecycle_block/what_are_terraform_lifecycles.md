## TERRAFORM LIFECYCLE RULES
---

## 🌱 1. **What Are Terraform Lifecycle Rules?**

Every Terraform resource can have a **`lifecycle` block** inside it.
This block gives you **fine-grained control** over Terraform’s behavior during:

* **Creation**
* **Update**
* **Replacement**
* **Destruction**

It’s especially useful when:

* You want to **prevent accidental deletions**
* You need to **control dependency order**
* You want to **keep existing resources** instead of recreating them

---

## 🧩 2. **Lifecycle Block Structure**

```hcl
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
    ignore_changes        = [tags, user_data]
  }
}
```

---

## ⚙️ 3. **Main Lifecycle Arguments**

Let’s break down each of them 👇

---

### 🔹 1. `create_before_destroy`

**Purpose:**
Tells Terraform to **create the new resource first** before destroying the old one.

This avoids downtime when replacing resources.

**Example:**

```hcl
resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}
```

🟢 Terraform will:

1. Create a new EC2 instance
2. Then destroy the old one

✅ Useful when:

* You need **zero downtime** deployments
* You’re replacing resources like EC2 instances, Load Balancers, etc.

---

### 🔹 2. `prevent_destroy`

**Purpose:**
Stops Terraform from accidentally deleting a resource — even if it’s removed from the configuration.

**Example:**

```hcl
resource "aws_s3_bucket" "important_data" {
  bucket = "critical-bucket"

  lifecycle {
    prevent_destroy = true
  }
}
```

🛑 If you try to run `terraform destroy`, Terraform will show:

```
Error: Instance cannot be destroyed
```

✅ Use this for:

* Production databases
* S3 buckets with critical data
* Long-lived environments

---

### 🔹 3. `ignore_changes`

**Purpose:**
Tells Terraform to **ignore changes** to specific arguments, even if they differ from your configuration.

**Example:**

```hcl
resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
  tags = {
    Environment = "dev"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
```

🟢 Terraform will not attempt to update `tags`, even if they’re modified outside Terraform (e.g., in the AWS Console).

✅ Use this when:

* Other tools modify certain fields
* You want Terraform to **“look but not touch”** those fields

---

### 🔹 4. `replace_triggered_by`

**Purpose:**
Forces Terraform to **recreate this resource** when another resource or attribute changes.

**Example:**

```hcl
resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t2.micro"

  lifecycle {
    replace_triggered_by = [aws_security_group.web_sg]
  }
}
```

🟢 When the security group changes, the EC2 instance will also be replaced.

✅ Useful for:

* Resources that must be rebuilt after dependency changes (e.g. networking or security updates)

---

## 🧱 4. **Example: Combined Lifecycle Rules**

```hcl
resource "aws_s3_bucket" "static_site" {
  bucket = "terraform-lifecycle-demo"
  acl    = "private"

  lifecycle {
    prevent_destroy       = true
    ignore_changes        = [acl]
    create_before_destroy = true
  }
}
```

🧠 Terraform behavior here:

1. Will **never delete** the bucket
2. Will **ignore ACL changes** (manual changes in AWS won’t trigger updates)
3. If replacement ever needed, **creates a new bucket first**

---

## 🚦 5. **Common Use Cases**

| Scenario                                           | Lifecycle Rule          |
| -------------------------------------------------- | ----------------------- |
| Protect critical resources (databases, S3 buckets) | `prevent_destroy`       |
| Avoid downtime when replacing                      | `create_before_destroy` |
| Ignore drift caused by manual changes              | `ignore_changes`        |
| Force replacement when dependency changes          | `replace_triggered_by`  |

---

## 🧠 6. **Pro Tip**

You can use **`lifecycle` inside modules** too — it behaves the same way.
For example, to ensure a VPC is created before a subnet, or to protect infrastructure managed by a shared module.

---

## ✅ 7. **Summary**

| Setting                 | Purpose               | Example                   |
| ----------------------- | --------------------- | ------------------------- |
| `create_before_destroy` | Avoid downtime        | Blue-green deployments    |
| `prevent_destroy`       | Protect from deletion | S3 buckets, databases     |
| `ignore_changes`        | Ignore drift          | Fields changed manually   |
| `replace_triggered_by`  | Force recreation      | Dependency-based rebuilds |

---

## MORE ABOUT **create_before_destroy**

---

## 🧩 1️⃣ `create_before_destroy` — what *really* happens

> **"That means that there will be another instance of the EC2 created when the old one is destroyed?"**

✅ Yes — that’s correct.
Terraform will **create a new resource first**, then **destroy the old one afterward**.

---

### 🧠 Example

```hcl
resource "aws_instance" "web" {
  ami           = "ami-abc123"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}
```

If you change the AMI, Terraform will:

1. Launch a **new EC2 instance**
2. Wait for it to become ready
3. **Then destroy** the old instance

🟢 This is similar to what an **Auto Scaling Group (ASG)** does with `min_size = 1`,
but it’s **Terraform-controlled**, not AWS-managed.

---


## 🧩 2️⃣ How to *completely terminate* a resource (even with lifecycle rules)

If you have `create_before_destroy = true`, Terraform will still destroy it *after* creating the new one.

However, if you’ve also set `prevent_destroy = true`, then destruction is blocked.

To **completely terminate** it:

### ✅ Option 1: Temporarily remove `prevent_destroy`

1. Edit your resource:

   ```hcl
   lifecycle {
     prevent_destroy = false
   }
   ```
2. Run:

   ```bash
   terraform apply
   terraform destroy
   ```

---

### ✅ Option 2: Use the `-target` flag (less recommended)

If you only want to destroy a specific resource:

```bash
terraform destroy -target=aws_instance.web
```

…but this will **still fail** if `prevent_destroy` is true.
You *must* disable that rule first.

---

## 🧩 3️⃣ `prevent_destroy` — what it really means

> **“Does this mean this resource will never be destroyed?”**

✅ Yes — Terraform will **refuse to delete** the resource as long as that rule exists.


---

### 🧠 Why it’s important

This is a **safety lock** to prevent human mistakes — especially for:

* Production databases
* S3 buckets with data
* Long-lived environments

---

### 🔓 How to “go around” it

You must **manually remove or comment out** `prevent_destroy` first:

```hcl
# lifecycle {
#   prevent_destroy = true
# }
```

Then run:

```bash
terraform apply
terraform destroy
```

There’s no flag or override to bypass it — Terraform intentionally requires **explicit manual removal**
to ensure you *really mean* to destroy it.

---

## WHAT HAPPENS WHEN BOTH `create_before_destroy` **and** `prevent_destroy`  ARE SET

---

## 🚦 If both `create_before_destroy` **and** `prevent_destroy` are set:

```hcl
lifecycle {
  create_before_destroy = true
  prevent_destroy        = true
}
```

Terraform’s behavior will actually **not** result in “+1” instance permanently — because **the operation cannot proceed at all**.

---

### 🧠 Here’s what happens step by step

1. Terraform detects that a change (e.g., new AMI, tag, or name) requires **replacement** of the resource.

2. The lifecycle rules tell Terraform:

   * `create_before_destroy` → “Okay, first create a new one.”
   * `prevent_destroy` → “But you can’t destroy the old one.”

3. Terraform realizes that it **cannot destroy** the old instance **after creating the new one**,
   so it **aborts the operation entirely**.

---

