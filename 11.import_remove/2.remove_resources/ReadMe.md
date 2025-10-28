
## REMOVING TERRAFORM RESOURCE

## 🧩 1. Understand What “Removing a Resource” Means

Terraform keeps a **state file** (`terraform.tfstate`) that tracks which real-world resources it manages.

If you want to **stop Terraform from managing** a resource — but **not delete it** in AWS —
you remove it **from the state**, not from AWS itself.

If you want to **delete** it both from Terraform *and* AWS, you’d instead run `terraform destroy`.

---

## 🧹 2. Option A – Remove from State (Keep Resource in Cloud)

This is the **safe** way to “untrack” a resource but leave it alive in AWS.

### Command:

```bash
terraform state rm <resource_address>
```

### Example:

```bash
terraform state rm aws_s3_bucket.demo_bucket
```

✅ This will:

* Remove the S3 bucket **from Terraform’s state file**
* Leave the **real bucket intact** in AWS

---

### 🔍 Verify:

```bash
terraform state list
```

You’ll see that `aws_s3_bucket.demo_bucket` is gone.

Terraform will now **ignore** that bucket on future plans or applies.

---

## 💣 3. Option B – Remove from Config (and Destroy It)

If you want Terraform to **delete** the resource in both Terraform **and** the real world:

1. Delete or comment out the resource block in your `.tf` file.

2. Run:

   ```bash
   terraform plan
   ```

   Terraform will show:

   ```
   - destroy
   ```

3. Then apply the change:

   ```bash
   terraform apply
   ```

✅ This physically destroys the resource in the provider (e.g., AWS).

---

## ⚙️ 4. Option C – Move Resource to a Different Workspace or Module

Sometimes you just want to **reorganize** resources, not delete them.

You can move them between modules or workspaces safely using:

```bash
terraform state mv <old_address> <new_address>
```

Example:

```bash
terraform state mv aws_s3_bucket.demo_bucket module.storage.aws_s3_bucket.bucket
```

This keeps it in Terraform’s state but changes its logical location in the configuration.

---

## 📘 Summary Table

| Goal                          | Command                                        | What Happens                             |
| ----------------------------- | ---------------------------------------------- | ---------------------------------------- |
| **Untrack (keep in AWS)**     | `terraform state rm aws_s3_bucket.demo_bucket` | Removes from state, keeps resource alive |
| **Destroy (delete from AWS)** | Delete resource block + `terraform apply`      | Deletes resource completely              |
| **Move within Terraform**     | `terraform state mv old new`                   | Moves resource tracking between modules  |

---

## 🧠 Best Practices

✅ **Before removing**, always back up your state file:

```bash
cp terraform.tfstate terraform.tfstate.backup
```

✅ **Never manually edit** the `.tfstate` file — use `terraform state` commands instead.

✅ If you remove a resource with `state rm`, document it, so future Terraform users know it’s now unmanaged.

---

### 🔁 Quick Recap

| Action               | Keeps Resource in Cloud? | Keeps Resource in State? |
| -------------------- | ------------------------ | ------------------------ |
| `terraform destroy`  | ❌ No                     | ❌ No                     |
| `terraform state rm` | ✅ Yes                    | ❌ No                     |
| `terraform state mv` | ✅ Yes                    | ✅ Yes (moved)            |

---

✅ **In short:**

> * Use `terraform import` to **add** existing resources to Terraform.
> * Use `terraform state rm` to **remove** them from Terraform (without deleting).
> * Use `terraform destroy` to **delete** them from both Terraform and the cloud.

---
