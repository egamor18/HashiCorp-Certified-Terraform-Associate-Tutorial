### TERRAFORM REFACTORING

---

## 🧩 Step 1 — Original simple resource

You start with a **single file** resource:

```hcl
resource "local_file" "example" {
  content  = "Hello, Terraform!"
  filename = "${path.module}/hello.txt"
}
```

➡️ This creates one file called `hello.txt` in your working directory.

Terraform state stores it as:

```
local_file.example
```

---

## 🧱 Step 2 — Refactor goal

You now want **multiple files** (say, one small and one big file),
but manage them **from one resource block**.

---

## ⚙️ Step 3 — Define a local map

```hcl
locals {
  files = {
    small = { content = "This is the small file" }
    big   = { content = "This is the big file" }
  }
}
```

Now `local.files` contains two key–value pairs:

| Key     | Value                                    |
| ------- | ---------------------------------------- |
| `small` | `{ content = "This is the small file" }` |
| `big`   | `{ content = "This is the big file" }`   |

---

## 🔁 Step 4 — Use `for_each` to generate multiple files

```hcl
resource "local_file" "example" {
  for_each = local.files
  content  = each.value.content
  filename = "${path.module}/${each.key}.txt"
}
```

### Here’s what’s happening:

* Terraform loops through `local.files`.
* For each entry:

  * `each.key` is `"small"` or `"big"`.
  * `each.value.content` is the content string.
* It creates:

  * `local_file.example["small"]` → writes `small.txt`
  * `local_file.example["big"]` → writes `big.txt`

---

### Why `each.value.content` and not `each.value.small`?

Because `each.value` represents *the current map element being iterated over*.
Terraform automatically substitutes the right key each time —
you don’t manually reference `"small"` or `"big"` inside the block.

---

## 🧭 Step 5 — Preserve the old file using `moved`

After refactoring, Terraform expects:

```
local_file.example["small"]
local_file.example["big"]
```

But the old state still contains:

```
local_file.example
```

Without a migration, Terraform would delete the old file and create new ones.
To prevent that, you add a `moved` block:

```hcl
moved {
  from = local_file.example
  to   = local_file.example["small"]
}
```

This tells Terraform:

> “The resource previously known as `local_file.example` is now `local_file.example["small"]`.”

It moves the state, so the file isn’t recreated.

---

## 🧾 Step-by-step summary

| Step | Description                     | Result                                              |
| ---- | ------------------------------- | --------------------------------------------------- |
| 1    | Original single file            | `hello.txt` created                                 |
| 2    | Add `locals` map                | Define multiple file configs                        |
| 3    | Add `for_each`                  | Loop through files to create `small.txt`, `big.txt` |
| 4    | Use `each.key` and `each.value` | Correctly map content and filenames                 |
| 5    | Add `moved`                     | Keep existing file as `small.txt` without deletion  |

---

## ✅ Final Result

After applying the refactor:

* Terraform manages:

  * `local_file.example["small"]` → small.txt
  * `local_file.example["big"]` → big.txt
* The old single file resource has been renamed smoothly in state.

---
