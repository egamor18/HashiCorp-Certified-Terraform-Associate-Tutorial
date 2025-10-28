
---

# 🍎 Terraform Collections — Working with Maps

## 📘 Introduction

This demo shows how **maps** work in Terraform.
A **map** is a collection of **key–value pairs**, similar to a dictionary or hash table in programming languages.

Maps are used to associate specific keys (like names or IDs) with corresponding values (like colors or configurations).
They allow you to **look up** or **loop through** data efficiently.

---

## 🧩 Code Overview

```hcl
# Demonstration of Terraform map

variable "fruit_colors" {
  type = map(string)
  default = {
    apple  = "red"
    banana = "yellow"
    cherry = "dark red"
  }
}

# Output only banana's color
output "banana_color" {
  value = var.fruit_colors["banana"]
}

# Output all fruit-color pairs
output "all_fruit_colors" {
  value = { for i, c in var.fruit_colors : i => c }
}
```

---

## ⚙️ How It Works

### 1. **Define a Map Variable**

```hcl
variable "fruit_colors" {
  type = map(string)
  default = {
    apple  = "red"
    banana = "yellow"
    cherry = "dark red"
  }
}
```

This creates a **map of fruit names (keys)** to their **colors (values)**:

```hcl
{
  "apple"  = "red"
  "banana" = "yellow"
  "cherry" = "dark red"
}
```

---

### 2. **Access a Single Item**

```hcl
output "banana_color" {
  value = var.fruit_colors["banana"]
}
```

Uses **key-based lookup** to return a specific value from the map.

Example output:

```
banana_color = "yellow"
```

---

### 3. **Output All Key–Value Pairs**

```hcl
output "all_fruit_colors" {
  value = { for i, c in var.fruit_colors : i => c }
}
```

Uses a **for expression** to iterate over the entire map and output all items.
This is useful when transforming or filtering map data.

Example output:

```
all_fruit_colors = {
  "apple"  = "red"
  "banana" = "yellow"
  "cherry" = "dark red"
}
```

---

## 🚀 How to Run the Demo

1. **Initialize Terraform**

   ```bash
   terraform init
   ```

2. **Preview Outputs**

   ```bash
   terraform plan
   ```

3. **Apply Configuration**

   ```bash
   terraform apply
   ```

4. **View Outputs**

   ```bash
   terraform output
   ```

---

## 🧠 Key Takeaways

* A **map** stores data in **key–value pairs**.
* You can **access specific elements** using the key name.
* Maps are **unordered** but are ideal for structured configuration data.
* You can **iterate** through maps using Terraform’s `for` expressions.

---
