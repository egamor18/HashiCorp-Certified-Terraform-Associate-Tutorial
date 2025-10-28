

### ITERATION OVER COLLECTIONS USING **`count`**, **`for_each`**, and **`for` loops** with **local resources**
---

## ⚙️ Prerequisite

Add this to your `main.tf` first:

```hcl
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}
```

---

## 🍏 1. Using `count` — create one file per list item

```hcl
variable "fruit_list" {
  type    = list(string)
  default = ["apple", "banana", "cherry"]
}

resource "local_file" "fruit_file" {
  count    = length(var.fruit_list)
  content  = "This file is about ${var.fruit_list[count.index]}"
  filename = "${path.module}/fruit_${var.fruit_list[count.index]}.txt"
}

output "created_files" {
  value = [for i in local_file.fruit_file : i.filename]
}
```

🧠 **Explanation:**

* Terraform creates 3 files:

  * `fruit_apple.txt`
  * `fruit_banana.txt`
  * `fruit_cherry.txt`
* Each file’s content describes the fruit.
* You access each with an index (e.g. `local_file.fruit_file[0].filename`).

---

## 🍌 2. Using `for_each` — create files by name (stable identifiers)
**for_each** is used exclusively with maps or sets. To use it with a list requires that you convert to set using toset(list). But remember set outputs only unique values and if this is not what you want, then use count for the list.

```hcl
variable "fruit_set" {
  type    = set(string)
  default = ["apple", "banana", "cherry"]
}

resource "local_file" "fruit_file" {
  for_each = var.fruit_set
  content  = "This file is about ${each.key}"
  filename = "${path.module}/fruit_${each.key}.txt"
}

output "created_files" {
  value = [for k, v in local_file.fruit_file : v.filename]
}
```

🧠 **Explanation:**

* One file per fruit.
* Terraform identifies each resource by the key (`apple`, `banana`, `cherry`), not an index.
* So removing `"banana"` later doesn’t break the others (stable references).

Access one directly:

```hcl
local_file.fruit_file["apple"].filename
```
✅ **each.key → works because in a set, the value itself acts as the key.**
(There’s no each.value because sets don’t have key/value pairs.)
---

## 🍒 3. Using a `for` loop — transform or generate file data dynamically

`for` loops don’t create resources — but they’re perfect for **creating data** used by resources.

### Example: create files only for long fruit names

```hcl
variable "fruit_list" {
  default = ["apple", "banana", "kiwi", "cherry"]
}

locals {
  long_fruits = [for fruit in var.fruit_list : fruit if length(fruit) > 5]
}

resource "local_file" "long_fruit_file" {
  for_each = toset(local.long_fruits)
  content  = "This fruit has a long name: ${each.key}"
  filename = "${path.module}/long_${each.key}.txt"
}

output "long_fruits" {
  value = local.long_fruits
}
```

📦 Terraform creates:

```
long_banana.txt
long_cherry.txt
```

🧠 The `for` loop filtered the list first, then `for_each` created the files.

---

## 🍇 4. Combining `for` and `for_each`

You can even **generate a map** from a list with a `for` loop, then use `for_each` to create local files.

```hcl
variable "fruit_list" {
  default = ["apple", "banana", "cherry"]
}

locals {
  fruit_map = { for fruit in var.fruit_list : fruit => upper(fruit) }
}

resource "local_file" "fruit_file" {
  for_each = local.fruit_map
  content  = "Fruit name: ${each.key}, Uppercase: ${each.value}"
  filename = "${path.module}/map_${each.key}.txt"
}

output "fruit_map" {
  value = local.fruit_map
}
```

📦 Output files:

```
map_apple.txt
map_banana.txt
map_cherry.txt
```

Each file contains something like:

```
Fruit name: apple, Uppercase: APPLE
```

---

## 🧠 Summary Table

| Concept      | Works With  | Key Variable             | Best For                       | Example Output                                |
| ------------ | ----------- | ------------------------ | ------------------------------ | --------------------------------------------- |
| **count**    | List        | `count.index`            | Repeating identical resources  | `fruit_apple.txt`, `fruit_banana.txt`         |
| **for_each** | Set or Map  | `each.key`, `each.value` | Named, unique resources        | `fruit_apple.txt`, `fruit_banana.txt`         |
| **for loop** | Expressions | custom variable          | Filtering or transforming data | `[apple, cherry] → [for fruit in list : ...]` |

---


### 🧭 Terraform Collections and Iterations Rule of Thumb

| Data Type       | Best Used With | Purpose / Notes                                                                                                     |
| --------------- | -------------- | ------------------------------------------------------------------------------------------------------------------- |
| **list**        | `count`        | Use when you only care about *position/index* — e.g. `var.list[count.index]`. Creates N resources, one per element. |
| **set(string)** | `for_each`     | Use when you want *unique* unordered values. The set items become the keys (`each.key`).                            |
| **map**         | `for_each`     | Use when you want *key/value* control. You get both `each.key` and `each.value`. Most flexible and predictable.     |

---

### 🧩 Additional Key Points

* ✅ `count` and `for_each` **create multiple resource instances**.
  Each will appear in state as separate resources (e.g. `aws_instance.example[0]` or `aws_instance.example["apple"]`).

* ⚙️ `for` (inside expressions) **does NOT create resources**.
  It’s only used to **generate or transform values**

---

### 💡 Handy Mnemonics

| Concept    | Think of it as...                  |
| ---------- | ---------------------------------- |
| `count`    | “Repeat N times”                   |
| `for_each` | “One per unique key/value”         |
| `for`      | “Loop for expression results only” |

---
