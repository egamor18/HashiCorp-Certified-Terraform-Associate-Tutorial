
---

# 🍊 Terraform Collections — Working with Sets

## 📘 Introduction

This demo shows how **Terraform sets** work.
A **set** is a collection type that contains **unique values only**, meaning duplicates are automatically removed.

Unlike **lists**, sets:

* Are **unordered** (no guaranteed order)
* Automatically **de-duplicate** items
* Cannot be indexed directly (must be converted to a list if you need indexing)

Sets are great when you only care about *which* elements exist, not *in what order*.

---

## 🧩 Code Overview

```hcl
# Demonstrating Terraform set
# A set automatically removes duplicate values

variable "fruit_set" {
  type    = set(string)
  default = ["apple", "banana", "apple"]
}

# Output unique fruit names
output "unique_fruits" {
  value = var.fruit_set
}

# Select one fruit (convert to list first)
output "one_fruit" {
  value = tolist(var.fruit_set)[1]
}
```

---

## ⚙️ How It Works

### 1. **Define a Set Variable**

```hcl
variable "fruit_set" {
  type    = set(string)
  default = ["apple", "banana", "apple"]
}
```

Terraform automatically **removes duplicates**, so even though `"apple"` appears twice, the resulting set only contains:

```
["apple", "banana"]
```

### 2. **Output the Unique Values**

```hcl
output "unique_fruits" {
  value = var.fruit_set
}
```

Displays all unique elements in the set.

Example output:

```
unique_fruits = [
  "apple",
  "banana",
]
```

### 3. **Access an Element by Index**

```hcl
output "one_fruit" {
  value = tolist(var.fruit_set)[1]
}
```

Since sets are **unordered**, you can’t directly index them.
Here, the set is first converted into a **list** using `tolist()` — which allows indexed access.
⚠️ The order of elements may vary between runs, since sets don’t preserve order.

Example output (order not guaranteed):

```
one_fruit = "banana"
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

* A **set** automatically **removes duplicate values**.
* Sets are **unordered** — order is *not guaranteed*.
* To access items by index, first **convert to a list** using `tolist()`.
* Best used when you only care about the *existence* of elements, not their *position*.

---
