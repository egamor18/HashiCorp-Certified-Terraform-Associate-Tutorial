### 🧭 What is a Terraform Workspace?

A **Terraform workspace** is an isolated environment that maintains its **own separate state file**.
By default, Terraform uses a single workspace called **`default`**, but you can create additional ones (e.g., `dev`, `staging`, `prod`) to manage multiple environments using the **same configuration code**.

Each workspace has its own state (`terraform.tfstate`), meaning resources created in one workspace don’t affect resources in another — even though they use the same `.tf` files.

---

### 💡 Benefits of Terraform Workspaces

1. **Environment Separation**

   * Easily manage different environments (e.g., `dev`, `test`, `prod`) without duplicating code.
   * Each workspace keeps its own isolated state file.

2. **Code Reusability**

   * Use the same Terraform configuration for multiple deployments by simply switching workspaces.

3. **Safer Testing**

   * You can experiment or test infrastructure changes in a non-production workspace before applying them to production.

4. **Simplified Multi-Region or Multi-Account Management**

   * Workspaces can represent different AWS regions or accounts, making regional or account-based deployments clean and organized.

5. **Dynamic Context via `terraform.workspace`**

   * The built-in variable `terraform.workspace` can be used in resource names, tags, or variables to automatically adjust configurations per workspace.

---

**Example:**

```hcl
tags = {
  Environment = terraform.workspace
}
```

If you switch to the `dev` workspace, the tag will automatically become:

```
Environment = "dev"
```

👉 In short: **Workspaces = multiple environments, one configuration.**


---

# 🌍 Terraform Multi-Workspace Demo (us-east-1 & us-west-2)

This Terraform configuration demonstrates how to use **Terraform workspaces** to manage resources across multiple AWS regions — in this case, **us-east-1** and **us-west-2**.

---

## 🧱 1. Initialize the Terraform Workspace

Before running any commands, initialize your working directory to download the necessary provider plugins.

```bash
terraform init
```

This sets up your local environment to use the AWS provider defined in the configuration.

---

## 🧭 2. View the Default Workspace

Terraform starts with a default workspace automatically created.

```bash
terraform workspace show
```

You should see:

```
default
```

This means you are currently working in the **default** workspace.

---

## ☁️ 3. Deploy Resources in Default Workspace (Region: us-east-1)

In this setup, we assume the **default workspace** corresponds to the **us-east-1** region.

Run the following commands to create resources in this region:

```bash
terraform plan
terraform apply
```

Terraform will:

* Fetch the latest Ubuntu AMI (`22.04 Jammy`)
* Deploy an EC2 instance (`t3.micro`) in **us-east-1**
* Output the AMI ID as a verification step

---

## 🧪 4. Create a New Workspace (dev)

Now let’s create a separate workspace for development, which will host resources in **us-west-2**.

```bash
terraform workspace new dev
```

Terraform will automatically switch to this new workspace.

You can confirm with:

```bash
terraform workspace show
```

Expected output:

```
dev
```

---

## 🔁 5. Update Provider Region (to us-west-2)

Edit the `provider` block in your configuration to specify **us-west-2** for the `dev` workspace:

```hcl
provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = {
      Environment = terraform.workspace
      Owner       = "Eric"
      Provisioned = "Terraform"
    }
  }
}
```

The `terraform.workspace` variable dynamically inserts the name of the current workspace (e.g., `default` or `dev`) into the tags.

---

## 🚀 6. Deploy Resources in the Dev Workspace

Now run:

```bash
terraform plan
terraform apply
```

Terraform will:

* Use the same configuration
* Deploy **a new EC2 instance** (t3.micro)
* But this time in **us-west-2**

Each workspace maintains its own **state file**, so the resources in `us-east-1` and `us-west-2` remain separate and independent.

---

## 🌎 7. Verify Results Across Regions

You can verify the deployments in both regions:

* Switch to the **default** workspace and inspect:

  ```bash
  terraform workspace select default
  terraform state list
  ```

  → Resources in **us-east-1**

* Switch to the **dev** workspace:

  ```bash
  terraform workspace select dev
  terraform state list
  ```

  → Resources in **us-west-2**

You can also confirm in the AWS Console by selecting the corresponding region in the upper-right region selector.

---

## ✅ Summary

| Workspace | AWS Region | Resource Created        |
| --------- | ---------- | ----------------------- |
| default   | us-east-1  | EC2 Instance (t3.micro) |
| dev       | us-west-2  | EC2 Instance (t3.micro) |

This setup demonstrates **multi-region deployments** using **Terraform workspaces**, ensuring clean separation of environments with minimal configuration changes.

---

Would you like me to extend this with a short **diagram or ASCII layout** showing how the two workspaces map to their regions and states (e.g., “default → us-east-1.tfstate”, “dev → us-west-2.tfstate”)? It’s a great visual addition for documentation.
