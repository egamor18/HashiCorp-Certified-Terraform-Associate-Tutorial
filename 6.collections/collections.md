
# COLLECTION TYPES IN TERRAFORM

---

## 🧩 1. List

### 🔹 What it is

A **list** is an **ordered sequence** of values — like an array in most programming languages.

### 🔹 Syntax

```hcl
["apple", "banana", "cherry"]
```

### 🔹 Example use

```hcl
variable "fruit_list" {
  type = list(string)
  default = ["apple", "banana", "cherry"]
}

output "second_fruit" {
  value = var.fruit_list[1] # → "banana"
}
```
---
### ACCESSING THE LIST



If you just want to display **one specific fruit**, say the second one (`banana`):

```hcl
output "second_fruit" {
  value = var.fruit_list[1]
}
```

---

If you want to **output all fruits**, you can directly output the entire list:

```hcl
output "all_fruits" {
  value = var.fruit_list
}
```

---

If you really need to output **each fruit individually**, you can use a **for expression** to make a map:

```hcl
output "fruit_buckets" {
  value = { for idx, fruit in var.fruit_list : idx => fruit }
}
```

This will give you:

```bash
fruit_buckets = {
  0 = "apple"
  1 = "banana"
  2 = "cherry"
}
```
---

NOTE:

* The **`count`** meta-argument **only works** for **resources**, **data sources**, or **modules**.
* It **does not work** for **output blocks**, **locals**, or **variables**.

Terraform doesn’t allow you to dynamically create multiple outputs with `count`.

---

### 🧠 Summary

| Goal                        | Correct approach         |
| --------------------------- | ------------------------ |
| Output one element          | `var.fruit_list[1]`      |
| Output whole list           | `value = var.fruit_list` |
| Output each with index      | `for` expression → map   |
| Use `count` in output block | ❌ Not supported          |


---

### 🔹 Key Traits Of Lists

| Property   | Value                         |
| ---------- | ----------------------------- |
| Order      | Preserved                     |
| Duplicates | Allowed                       |
| Access     | By index (e.g., `[0]`, `[1]`) |

---

## 🧩 2. Set

### 🔹 What it is

A **set** is an **unordered collection** of **unique** values — similar to a mathematical set.

### 🔹 Syntax

```hcl
["apple", "banana", "cherry"]
```

> (Same look as a list, but Terraform treats it differently.)

### 🔹 Example use

```hcl
variable "fruit_set" {
  type = set(string)
  default = ["apple", "banana", "apple"]
}

output "unique_fruits" {
  value = var.fruit_set
}
```
### Pick by index
Sets in Terraform are unordered — meaning you can’t reliably say “give me the first element.”
However, if you must pick one element, you have to convert the set to a list first.

```
output "one_fruit" {
  value = tolist(var.fruit_set)[0]
}

```

### 🔹 Key traits

| Property   | Value                                            |
| ---------- | ------------------------------------------------ |
| Order      | Not preserved                                    |
| Duplicates | **Removed automatically**                        |
| Access     | By value, not by index                           |
| Common use | When order doesn’t matter (e.g., resource names) |

---

## 🧩 3. Map

### 🔹 What it is

A **map** is a **collection of key–value pairs**, similar to a dictionary or object in other languages.

### 🔹 Syntax

```hcl
{
  apple  = "red"
  banana = "yellow"
  cherry = "dark red"
}
```

### 🔹 Example use

```hcl
variable "fruit_colors" {
  type = map(string)
  default = {
    apple  = "red"
    banana = "yellow"
    cherry = "dark red"
  }
}

output "banana_color" {
  value = var.fruit_colors["banana"]
}
```

### 🔹 Key traits

| Property   | Value                                                        |
| ---------- | ------------------------------------------------------------ |
| Order      | Not preserved                                                |
| Access     | By key (e.g., `["apple"]`)                                   |
| Duplicates | Keys must be unique                                          |
| Common use | For key-based configurations (e.g., `bucket_name = "value"`) |

---

## ⚙️ Comparison Summary

| Type     | Ordered? | Duplicates?                | Access   | Common Use                           |
| -------- | -------- | -------------------------- | -------- | ------------------------------------ |
| **List** | ✅ Yes    | ✅ Allowed                  | By index | Ordered values like names, IDs       |
| **Set**  | ❌ No     | ❌ Removed                  | By value | Unique unordered items               |
| **Map**  | ❌ No     | ✅ Values yes (keys unique) | By key   | Key–value settings or configurations |

---

## 🧠 Practical analogy

Imagine you’re organizing fruit in baskets 🍎🍌🍒

| Type     | Analogy                                                            |
| -------- | ------------------------------------------------------------------ |
| **List** | Fruits lined up in a row (you care about their order).             |
| **Set**  | Fruits thrown into a basket (order doesn’t matter, no duplicates). |
| **Map**  | Labeled baskets (key = basket label, value = fruit inside).        |

---
