## TERRAFORM VALIDATION BLOCK

The **`validation` block** in Terraform is used **inside a `variable` definition** to **validate the input values** that users provide — whether they’re typed in the terminal, defined in `.tfvars`, or passed through a CI/CD pipeline.

---

### 🔍 Purpose

The validation block helps you:

* Enforce **rules and constraints** on variables.
* Prevent invalid or unsafe input values before Terraform runs.
* Provide **clear error messages** when users supply incorrect inputs.

It acts as a **"guardrail"** to keep your configuration consistent and predictable.

---

### 🧱 Example

```hcl
# the variable and its name
variable "region" {
  type = string

  #validation block
  validation {
    condition     = contains(["us-east-1", "us-east-2", "eu-north-1"], lower(var.region))
    error_message = "You must use an approved region: us-east-1, us-east-2, eu-north-1"
  }
}

```

**✅ Works**

```bash
terraform plan -var region="us-east-1"
```

**❌ Fails**

```bash
terraform plan -var region="us-west-1"
```

Output:

```
Error: Invalid value for variable
You must use an approved region: us-east-1, us-east-2, eu-north-1.
```

---

### ⚙️ How It Works

Each `validation` block has **two required arguments**:

| Argument            | Description                                                                          |
| ------------------- | ------------------------------------------------------------------------------------ |
| **`condition`**     | A boolean expression that must evaluate to `true` for Terraform to accept the value. |
| **`error_message`** | A user-friendly message displayed if the condition is `false`.                       |

---

### 🧩 Multiple Validation Blocks

You can include **multiple validation blocks** per variable.
Terraform will check each condition in order and fail at the first that doesn’t pass.

```hcl
variable "username" {
  type = string

  validation {
    condition     = length(var.username) >= 3
    error_message = "Username must be at least 3 characters long."
  }

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.username))
    error_message = "Username can only contain lowercase letters and digits."
  }
}
```

---

### 💡 Best Practices

* Use **lower()**, **regex()**, and **contains()** to handle text checks.
* Provide **clear and specific error messages**.
* Combine validation with **default values** when appropriate.
* Use **type constraints** (e.g., `string`, `number`, `map`) alongside validation for stronger input control.

---



## MORE ABOUT THE CONDITION

```hcl
condition = contains(["us-east-1", "us-east-2", "eu-north-1"], lower(var.region))
```

---

### 1️⃣ **Purpose**

This line is inside a **`validation` block** of a Terraform variable. Its goal is to **ensure that the user provides a valid AWS region** when setting `var.region`.

---

### 2️⃣ **`contains(list, value)` Function**

* **`contains(list, value)`** checks if a given **value exists in a list**.
* Returns `true` if the value is in the list; otherwise `false`.

**Example:**

```hcl
contains(["a", "b", "c"], "b")   # returns true
contains(["a", "b", "c"], "x")   # returns false
```

---

### 3️⃣ **`lower(var.region)`**

* **`lower()`** converts a string to **all lowercase**.
* This ensures that if the user inputs `"US-EAST-1"` or `"us-east-1"`, it’s normalized to `"us-east-1"` before validation.

---

### 4️⃣ **Putting It Together**

```hcl
contains(["us-east-1", "us-east-2", "eu-north-1"], lower(var.region))
```

* Takes the user input for `var.region`.
* Converts it to lowercase using `lower()`.
* Checks if the lowercase value is in the **allowed list of regions**: `["us-east-1", "us-east-2", "eu-north-1"]`.
* Returns **true** if the region is valid, **false** if it’s not.

---

### 5️⃣ **Example Usage**

**Valid Input:**

```bash
terraform plan -var 'region=US-EAST-1'
```

* `lower("US-EAST-1")` → `"us-east-1"`
* `"us-east-1"` is in the list → ✅ Validation passes

**Invalid Input:**

```bash
terraform plan -var 'region=ap-south-1'
```

* `"ap-south-1"` is not in the list → ❌ Validation fails
* Terraform shows the **error_message** from the validation block.

---

In short:

> This line ensures that **only approved AWS regions** are accepted for the `region` variable, and it handles case-insensitive user input.

---
