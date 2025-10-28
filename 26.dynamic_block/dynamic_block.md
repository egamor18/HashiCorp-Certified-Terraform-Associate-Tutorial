
---

# 🧩 Terraform `dynamic` Block

## 🔹 **Purpose**

A **`dynamic` block** allows you to **generate nested blocks dynamically** in Terraform configurations.
This is useful when you want to create multiple nested blocks (like tags, ingress rules, lifecycle rules) **based on a list or map**, instead of writing each block manually.

Without `dynamic`, you’d need to copy-paste blocks for each item — which is repetitive and error-prone.

---

## 🔹 **Syntax**

```hcl
dynamic "BLOCK_LABEL" {
  for_each = COLLECTION
  content {
    ATTRIBUTE1 = BLOCK_EXPRESSION
    ATTRIBUTE2 = BLOCK_EXPRESSION
  }
}
```

**Explanation:**

* `BLOCK_LABEL`: the nested block you want to create (e.g., `ingress`, `lifecycle_rule`, `tags`)
* `for_each`: the list or map to iterate over
* `content {}`: the actual attributes of the nested block

---

## 🔹 **Simple Example: AWS Security Group Ingress**

Suppose you have multiple ingress rules in a list:

```hcl
variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    { from_port = 80,  to_port = 80,  protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  ]
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Web security group"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
```

### ✅ **What happens here**

* Terraform loops over each element in `var.ingress_rules`.
* For each element, it creates an **`ingress` block** dynamically with the correct attributes.
* You no longer need to manually define multiple ingress blocks.

---

## 🔹 **Another Example: AWS S3 Bucket Lifecycle Rules**

```hcl
variable "lifecycle_rules" {
  default = [
    { id = "expire-temp", days = 30 },
    { id = "expire-logs", days = 90 }
  ]
}

resource "aws_s3_bucket" "example" {
  bucket = "dynamic-demo-bucket"

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      id      = lifecycle_rule.value.id
      enabled = true

      expiration {
        days = lifecycle_rule.value.days
      }
    }
  }
}
```

🟢 **Effect:**
Two lifecycle rules are generated automatically from the `lifecycle_rules` list — one for 30 days and one for 90 days.

---

## 🔹 **Key Points**

1. **Use for_each**: Iterates over a list or map to dynamically create blocks.
2. **`.value`**: Access the current item in the iteration (`map` or `object`).
3. **Avoid manual repetition**: Perfect for repeating nested blocks like tags, rules, or policies.
4. Works with any resource that supports nested blocks.

**Note** Overuse of dynamic blocks can make configuration hard to read and maintain, so it is recommend to
use them only when you need to hide details in order to build a clean user interface for a re-usable
module. Always write nested blocks out literally where possible.
---
