---

### 🧠 **Terraform Conditional Expression Syntax**

```hcl
condition ? true_value : false_value
```

Terraform evaluates the `condition`:

* If `true` → returns `true_value`
* If `false` → returns `false_value`

---

### 🧩 **Examples**

```hcl
provider "aws" {
  region = terraform.workspace == "dev" ? "us-west-2" : "us-east-1"
}
```

---

### 🧠 **Explanation**

* `terraform.workspace` → built-in variable that gives the current workspace name.
* The expression:

  ```hcl
  terraform.workspace == "dev" ? "us-west-2" : "us-east-1"
  ```

  means:

  * If the workspace name **is "dev"**, use `"us-west-2"`.
  * Otherwise, use `"us-east-1"`.

---

## AUTOMATING THE RESOURCE CREATION CONDITION STATEMENT

---

## 🧭 **Goal**

We’ll have:

* A **default** workspace → uses region **us-east-1**
* A **dev** workspace → uses region **us-west-2**

Each workspace deploys a simple EC2 instance in its own region.

---

## 🧩 **Terraform Configuration**

see script in main.tf

---

## 🧮 **How It Works**

| Workspace | Region      | Instance Tag           |
| --------- | ----------- | ---------------------- |
| `default` | `us-east-1` | workspace-demo-default |
| `dev`     | `us-west-2` | workspace-demo-dev     |

Terraform automatically evaluates:

```hcl
region = terraform.workspace == "dev" ? "us-west-2" : "us-east-1"
```

---

## ⚙️ **Workflow Steps**

```bash
# 1. Initialize Terraform
terraform init

# 2. See current workspace
terraform workspace show

# 3. Apply in default workspace (region = us-east-1)
terraform plan
terraform apply

# 4. Create a new workspace for dev
terraform workspace new dev

# 5. Apply in dev workspace (region = us-west-2)
terraform plan
terraform apply

# 6. List all workspaces
terraform workspace list

# 7. Confirm both regions have separate EC2 instances
```

---

