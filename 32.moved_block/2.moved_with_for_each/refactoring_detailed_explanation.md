
---

# 🧱 Terraform Refactor Example — Using `for_each` and `moved` with `local_file`

This example demonstrates how to **refactor** a single Terraform resource into **multiple instances** using `for_each`, and how to use the **`moved` block** to preserve state without destroying existing infrastructure.

---

## 🪜 1. Initial Configuration (Before Refactor)

```hcl
resource "local_file" "example" {
  content  = "Hello, Terraform!"
  filename = "${path.module}/hello.txt"
}
```

### State Summary

Terraform manages a single file resource:

```
local_file.example → ./hello.txt
```

### Excerpt from `terraform.tfstate`

```json
"resources": [
  {
    "type": "local_file",
    "name": "example",
    "instances": [
      {
        "attributes": {
          "content": "Hello, Terraform!",
          "filename": "./hello.txt"
        }
      }
    ]
  }
]
```

---

## 🧩 2. Refactored Configuration (Using `for_each`)

```hcl
locals {
  files = {
    small = { content = "This is the small file" }
    big   = { content = "This is the big file" }
  }
}

resource "local_file" "example" {
  for_each = local.files
  content  = each.value.content
  filename = "${path.module}/${each.key}.txt"
}

output "my_variable" {
  value = local.files["small"].content
}
```

Now Terraform will want to create **two files**:

```
local_file.example["small"] → ./small.txt
local_file.example["big"]   → ./big.txt
```

---

## ⚠️ 3. Problem Without a `moved` Block

If you just refactor and run `terraform apply`, Terraform will plan to **destroy** the old resource and **create** two new ones:

```
- destroy local_file.example (hello.txt)
+ create local_file.example["small"] (small.txt)
+ create local_file.example["big"] (big.txt)
```

This happens because the resource address (`local_file.example`) changed — Terraform doesn’t automatically know that `example["small"]` is a renamed version of the old resource.

---

## 🪄 4. Solution — The `moved` Block

To preserve your existing file and state, add a `moved` block:

```hcl
moved {
  from = local_file.example
  to   = local_file.example["small"]
}
```

This tells Terraform:

> “The resource previously known as `local_file.example` should now be considered `local_file.example["small"]`.”

### ✅ Resulting Behavior

```
~ rename local_file.example → local_file.example["small"]
+ create local_file.example["big"]
```

Terraform **updates** the state instead of destroying and recreating the resource.

---

## 🧾 5. State Comparison

### Before Refactor

* **One instance:** `local_file.example`
* **File:** `hello.txt`

### After Refactor + `moved`

* **Two instances:**

  * `local_file.example["small"]` → from old resource (retained)
  * `local_file.example["big"]` → newly created

### `"index_key"` Field

Each instance in state now has:

```json
"index_key": "small"
"index_key": "big"
```

These correspond to the map keys defined in the `local.files` variable.

---

## 📦 6. Example Output from State (After Refactor)

```json
"resources": [
  {
    "type": "local_file",
    "name": "example",
    "instances": [
      {
        "index_key": "big",
        "attributes": {
          "content": "This is the big file",
          "filename": "./big.txt"
        }
      },
      {
        "index_key": "small",
        "attributes": {
          "content": "This is the small file",
          "filename": "./small.txt"
        }
      }
    ]
  }
]
```

---

## 🧮 7. Terraform Console Exploration

You can inspect expressions interactively using:

```bash
terraform console
```

Example:

```bash
> local.files["small"].content
"This is the small file"
> local.files["big"].content
"This is the big file"
```

---

## ✅ Key Takeaways

| Concept              | Explanation                                                                          |
| -------------------- | ------------------------------------------------------------------------------------ |
| **`for_each`**       | Turns a single resource block into multiple instances, one per key.                  |
| **Resource address** | Each instance is identified by `["key"]` syntax.                                     |
| **`moved` block**    | Renames resources in the state file without destroying them.                         |
| **Goal**             | Safe, non-destructive refactoring when introducing `for_each` or changing addresses. |

---
