
---

# 🍎 Terraform Collections — Working with Lists

## 📘 Introduction

This demo shows how **Terraform collections** work — specifically **lists**.

A list in Terraform is an **ordered collection of values**, referenced by **numeric index**, starting from `0`.
Lists are useful when you need to store multiple values of the same type, such as names, instance types, or resource IDs.

This example demonstrates:

* How to define a **list variable**
* How to access individual elements using **index notation**
* How to **output** the entire list or transform it with a **for expression**

---

## 🧩 Code Overview

```hcl
# This demonstrates lists — a simple collection of items accessed by index.
# Because it is referenced by index, items do not need to be unique.

variable "fruit_list" {
  type    = list(string)
  default = ["apple", "banana", "cherry"]
}

# Output a single list element (by index)
output "second_fruit" {
  value = var.fruit_list[1] # → "banana"
}

# Output the entire list
output "all_fruit" {
  value = var.fruit_list
}

# Transform the list into a map (index => item)
output "looping_over_fruit" {
  value = { for i, f in var.fruit_list : i => f }
}
```

---

## ⚙️ How It Works

1. **Variable Definition**

   ```hcl
   variable "fruit_list" {
     type    = list(string)
     default = ["apple", "banana", "cherry"]
   }
   ```

   This defines a list of strings.
   Each element can be accessed using its **index position**:

   * `var.fruit_list[0]` → `apple`
   * `var.fruit_list[1]` → `banana`
   * `var.fruit_list[2]` → `cherry`

2. **Accessing a Single Element**

   ```hcl
   output "second_fruit" {
     value = var.fruit_list[1]
   }
   ```

   This outputs only the **second item**, `"banana"`.

3. **Displaying the Entire List**

   ```hcl
   output "all_fruit" {
     value = var.fruit_list
   }
   ```

   Terraform prints all items as a list.

   Example output:

   ```
   all_fruit = [
     "apple",
     "banana",
     "cherry",
   ]
   ```

4. **Looping with a For Expression**

   ```hcl
   output "looping_over_fruit" {
     value = { for i, f in var.fruit_list : i => f }
   }
   ```

   This converts the list into a **map**, pairing each item with its index.

   Example output:

   ```
   looping_over_fruit = {
     0 = "apple"
     1 = "banana"
     2 = "cherry"
   }
   ```

---

## 🚀 How to Run the Demo

1. **Initialize Terraform**

   ```bash
   terraform init
   ```

2. **Preview the Outputs**

   ```bash
   terraform plan
   ```

3. **Apply the Configuration**

   ```bash
   terraform apply
   ```

4. **Check the Results**

   ```bash
   terraform output
   ```

---

## 🧠 Key Takeaways

* A **list** is an **ordered collection** accessed by numeric index.
* List elements **don’t need to be unique**.
* The **index starts at 0**.
* Use **`for` expressions** to transform lists into maps or other structures.
* **`count`** is not supported in `output` blocks — use `for` loops instead.

---
