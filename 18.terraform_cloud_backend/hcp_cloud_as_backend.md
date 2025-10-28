
---

## 🧭 **Using Terraform HCP Cloud as Backend**

### **1. Introduction**

* Running Terraform **locally**, makes collaboration difficult.
* **HCP Terraform** enables **team collaboration**, providing:

  * Secure remote execution.
  * Centralized state storage.
  * Secure variable management (e.g., API tokens, credentials).
  * CLI integration for triggering remote runs.

---

### **2. Purpose of Tutorial**

* Migrate a **local Terraform workspace** to **HCP Terraform**.
* Use **CLI-driven workflow** to trigger remote runs.
* Learn about **VCS** and **API-driven workflows** (alternatives supported by HCP Terraform).

---

### **3. Prerequisites**

* Terraform CLI (v1.2.0+).
* AWS CLI.
* Our previously running terraform scripts.

---

### **4. Sign Up for HCP Terraform**

* Create an account on [HCP Terraform](https://app.terraform.io/).
* Confirm email → Create a new **organization**.
* Optionally reuse an existing account.

---

### **5. Log in via Terraform CLI**

a. Run `terraform login`.
b. Confirm prompt (`yes`).
c. Terraform opens browser → Generate API token.
d. Copy-paste token into CLI prompt.
e. Token saved to:

   ```
   ~/.terraform.d/credentials.tfrc.json
   ```
f. Confirms login and grants Terraform CLI access to HCP Terraform.

---

### **6. Connect Workspace to HCP Terraform**

* Edit `terraform.tf` to include a **cloud block**:

  ```hcl
  terraform {
    cloud {
      organization = "your-organization-name"

      workspaces {
        name    = "workspace-name"
        project = "your-project-name"
      }
    }
  }
  ```

* Replace `"your-organization-name"` accordingly.

---

### **7. Migrate Local State to HCP Terraform**

* Run `terraform init`.
* Terraform asks whether to migrate existing state:

  * Answer `yes` to upload your current state to HCP Terraform.
* Terraform sets up:

  * Project
  * Workspace
  * Remote backend for state storage.

---

### **8. Configure AWS Credentials in HCP Terraform**

* Go to your workspace → **Variables page**.
* Add:

  * `AWS_ACCESS_KEY_ID`
  * `AWS_SECRET_ACCESS_KEY`
* Mark both as **Sensitive** environment variables.

**NOTE** Environment variables are UPPER CASE. Writing it otherwise results in error.
---

### **9. Apply Configuration with HCP Terraform**

* Run the commands:

  ```bash
  terraform plan
  terraform apply
  ```
* This triggers a **remote plan and apply** in HCP Terraform.
* View run details via URL printed in the terminal.
* Output confirms creation of resources and remote state storage.

---

### **10. Verify Remote State**

* Terraform now:

  * Stores state **remotely** in HCP Terraform.
  * Streams plan/apply logs to your CLI.
* You can also review run history, outputs, and variables via the web interface.

---

### **11. Destroy Workspace**

* Run:

  ```bash
  terraform destroy
  ```
* Destroys all managed resources remotely.
* Confirm with `yes`.
* Once complete:

  * **Delete workspace** via
    *Settings → Destruction and Deletion → Delete from HCP Terraform.*
  * Optionally delete the entire **project** as well.

---

✅ **Key Takeaways**

* HCP Terraform centralizes Terraform management and collaboration.
* It prevents local state loss and allows secure team operations.
* Supports multiple workflows:

  * **CLI-driven**
  * **VCS-driven**
  * **API-driven**
* Provides visibility, security, and consistency in infrastructure management.

### **12. See Images for screenshots**
---
## MORE ABOUT THE WORKFLOWS

### 🧭 **Choosing the Right HCP Terraform Workflow**

#### **1. Version Control Workflow (VCS)**

✅ **Best for:** Teams using GitHub, GitLab, Bitbucket, or Azure Repos.

* Automatically triggers Terraform runs when code changes are pushed to the repo.
* Provides **full traceability** — every run is tied to a specific commit.
* Ideal for **collaborative teams** and production setups.
* Common for **GitOps** workflows.

📘 **Choose this if:**

* You use Git for version control.
* You want automatic runs after pull requests or merges.
* You need clear audit trails for compliance or teamwork.

---

#### **2. CLI-Driven Workflow**

✅ **Best for:** Individuals or small teams running Terraform manually from their local machine.

* You trigger runs using commands like:

  ```bash
  terraform apply
  ```
* The plan and apply still execute **remotely** in HCP Terraform, not locally.
* Simple setup — great for **learning**, **labs**, and **proof-of-concept** work.

📘 **Choose this if:**

* You’re following a tutorial or lab exercise.
* You prefer to work directly in the CLI.
* You don’t yet use Git integration or automated pipelines.

🧩 *This is the workflow used in most Terraform “Getting Started” demos.*

---

#### **3. API-Driven Workflow**

✅ **Best for:** Advanced automation and CI/CD pipelines.

* You trigger Terraform runs programmatically via API calls.
* Perfect for **custom workflows**, **non-human triggers**, or **large-scale automation**.

📘 **Choose this if:**

* You’re integrating Terraform with tools like Jenkins, GitHub Actions, or custom scripts.
* You want fine-grained control over when and how runs are triggered.

---

### ⚙️ **In Short:**

| Workflow            | Ideal For         | Trigger Type              | Best Use Case          |
| ------------------- | ----------------- | ------------------------- | ---------------------- |
| **Version Control** | Teams using Git   | Git commits/pull requests | Production deployments |
| **CLI-Driven**      | Individual users  | Manual CLI commands       | Labs, demos, testing   |
| **API-Driven**      | DevOps automation | API requests              | CI/CD integration      |

---

✅ **Recommendation for you (based on your current work):**
👉 **Choose the *CLI-Driven Workflow*.**
It’s perfect for hands-on learning and direct experimentation before moving to a VCS-driven setup later.
