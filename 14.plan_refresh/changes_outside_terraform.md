
## VIEWING CHANGES TO RESOURCES DONE OUTSIDE TERRAFORM : --> terraform plan -refresh-only

The `terraform plan -refresh-only` command is a **special type of Terraform plan** that only updates Terraform’s state to reflect the **current state of resources in your infrastructure**, without proposing any changes to actually modify or create resources.

Here’s a breakdown:

---

### What it does:

1. **Refreshes the state**
   Terraform queries the real infrastructure to see if any resources have changed outside of Terraform (e.g., someone manually updated an EC2 instance, S3 bucket, or security group).

2. **Does not change anything**
   Unlike a regular `terraform plan` or `terraform apply`, it **does not plan to create, modify, or destroy any resources**.

3. **Shows differences**
   It will display any **drifts** between your Terraform state file and the real infrastructure.

---

### When to use it:

* To **check for drift** in your infrastructure caused by manual changes.
* Before running `terraform apply` to see if Terraform thinks something has changed.
* When you want to **refresh state safely** without touching any resources.

---

### Example:

```bash
terraform plan -refresh-only
```

Output might show something like:

```
Terraform will perform the following actions:

  # aws_instance.web will be updated in-place
  ~ resource "aws_instance" "web" {
        id = "i-0123456789abcdef0"
      ~ instance_type = "t2.micro" -> "t3.micro" # Changed outside Terraform
    }
```

Notice the `~` symbol means Terraform detected a change in the **actual infrastructure**, but no changes will be applied automatically.

---

In short: **it’s a safe way to see what’s different in your infrastructure without actually applying any changes.**

---

## 🧪 Demo: Using `terraform plan -refresh-only`

This demo illustrates how `terraform plan -refresh-only` helps detect and sync changes that occur **outside Terraform** (for example, when an instance is manually stopped in the AWS Console). **We use the code in 1.log_demo**

---

### **Steps**

1. **Run Terraform plan and apply**

   ```bash
   terraform plan
   terraform apply
   ```

   ✅ This will create the infrastructure (e.g., EC2 instances) as defined in your configuration.

2. **Verify instance status**

   * Open the AWS Console.
   * Confirm that the instance(s) are **created and running**.

3. **Run `terraform plan` again**

   ```bash
   terraform plan
   ```

   🟢 Output: **“No changes. Infrastructure is up-to-date.”**

4. **Manually change the instance state**

   * Go to the AWS Console.
   * **Stop** one of the running instances.

5. **Run `terraform plan` again**

   ```bash
   terraform plan
   ```

   ⚠️ Output: Still **“No changes.”**

   > Terraform doesn’t automatically detect external changes until you refresh the state.

6. **Run `terraform plan -refresh-only`**

   ```bash
   terraform plan -refresh-only
   ```

   🔍 Output: Now Terraform **detects the stopped instance**.

   > This updates the plan to reflect the **real-world state** of the infrastructure.

7. **Update local state**

   ```bash
   terraform apply
   ```

   ✅ This updates Terraform’s **state file** to match the actual state in the cloud (the stopped instance).

8. **Run `terraform plan` again**

   ```bash
   terraform plan
   ```

   🟢 Output: **“No changes.”**

   > The local state file is now fully synchronized with the real infrastructure.

9. **Clean up**

   ```bash
   terraform destroy
   ```

   💥 Destroys all resources and cleans up the workspace.

---

### **Key Takeaway**

`terraform plan -refresh-only` is used to **detect and record** external (manual) changes in your infrastructure **without applying any modifications** — ensuring your **state file stays accurate and consistent** with the real environment.

---
