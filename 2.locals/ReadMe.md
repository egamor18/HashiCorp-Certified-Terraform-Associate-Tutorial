
# 🚀 Example: Using `locals` with an EC2 Instance

This demo shows how locals can simplify naming and tagging logic for an EC2 instance.

---

## 🧩 Step 1 — Configuration Files

### **code in main.tf**
 

---

## 🧠 Step 2 — Explanation

| Component                       | Description                                                           |
| ------------------------------- | --------------------------------------------------------------------- |
| **`locals` block**              | Defines internal variables used for naming and tagging.               |
| **`environment` and `project`** | Define context — used to build consistent names.                      |
| **`instance_name`**             | Combines `project` and `environment` dynamically.                     |
| **`common_tags`**               | A reusable map of tags applied to multiple resources.                 |
| **`merge()`**                   | Combines `common_tags` with a unique `Name` tag for the EC2 instance. |

---

## 🪄 Step 3 — Output

After you run:

```bash
terraform init
terraform apply
```

Terraform will create an EC2 instance with tags like:

| Key         | Value                  |
| ----------- | ---------------------- |
| Name        | `web-app-dev-instance` |
| Project     | `web-app`              |
| Environment | `dev`                  |
| ManagedBy   | `Terraform`            |

---

## ✅ Why Use `locals` Here

* Keeps resource names consistent and clean.
* Makes it easy to change the environment or project name once in one place.
* Allows for flexible reuse of logic across resources.

---
