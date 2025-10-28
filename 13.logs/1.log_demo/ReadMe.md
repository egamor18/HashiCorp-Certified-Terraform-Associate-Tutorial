
## TERRAFORM LOGS
---

## 🧠 What Are Terraform Logs?

Terraform produces **detailed logs** of what it’s doing behind the scenes —
API calls, provider operations, dependency graphs, and state actions.

By default, these logs are **not shown**, because Terraform focuses on concise CLI output.
But you can enable them when troubleshooting.

---

## 🪜 1. Enable Terraform Logging

Terraform uses an environment variable called `TF_LOG`.

You can set it **before running a Terraform command**.

### 🔧 Example (Linux/macOS)

```bash
export TF_LOG=INFO
terraform apply
```

### 🪟 Example (Windows PowerShell)

```powershell
$env:TF_LOG="INFO"
terraform apply
```

---

## ⚙️ 2. Log Levels

You can choose how detailed the logs should be.

| Level   | Description                                    |
| ------- | ---------------------------------------------- |
| `ERROR` | Only serious issues                            |
| `WARN`  | Warnings and errors                            |
| `INFO`  | Normal operations (good general choice)        |
| `DEBUG` | Very detailed, includes provider communication |
| `TRACE` | Extremely detailed (low-level function calls)  |

👉 Example:

```bash
export TF_LOG=DEBUG
```

---

## 📂 3. Write Logs to a File

You can also send logs to a file using the `TF_LOG_PATH` environment variable.

```bash
export TF_LOG=DEBUG
export TF_LOG_PATH=./terraform.log
terraform plan
```

✅ This will create a file named `terraform.log` in your current directory.

Afterward, you can read it:

```bash
less terraform.log
```

---

## 📘 4. Example Workflow

```bash
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform_debug.log
terraform apply
```

You’ll see verbose output like:

```
2025-10-13T10:15:41.123Z [DEBUG] provider.terraform-provider-aws_v5.1.0:
2025-10-13T10:15:41.124Z [DEBUG] AWS API Request: GET https://ec2.amazonaws.com/?Action=DescribeInstances
```

This helps you trace what API requests Terraform is making and why something might fail.

---

## 🧹 5. Disable Logging (After Debugging)

When you’re done debugging:

```bash
unset TF_LOG
unset TF_LOG_PATH
```

or in PowerShell:

```powershell
Remove-Item Env:TF_LOG
Remove-Item Env:TF_LOG_PATH
```

---

## 🪄 6. Common Use Cases

| Problem                  | Use Case                    | Example               |
| ------------------------ | --------------------------- | --------------------- |
| Resource fails to create | View AWS API responses      | `TF_LOG=DEBUG`        |
| State corruption issues  | Trace backend operations    | `TF_LOG=TRACE`        |
| Provider bugs            | Capture reproducible logs   | Save to `TF_LOG_PATH` |
| Module not behaving      | Check dependency resolution | `TF_LOG=INFO`         |

---

## 🧭 Summary

| Variable       | Purpose                                                    | Example                            |
| -------------- | ---------------------------------------------------------- | ---------------------------------- |
| `TF_LOG`       | Sets log level (`ERROR`, `WARN`, `INFO`, `DEBUG`, `TRACE`) | `export TF_LOG=DEBUG`              |
| `TF_LOG_PATH`  | File to write logs to                                      | `export TF_LOG_PATH=terraform.log` |
| `unset TF_LOG` | Disable logging                                            |                                    |

---

✅ **In short:**

> * Use `TF_LOG` to control **how much Terraform tells you**.
> * Use `TF_LOG_PATH` to **save logs for later review**.
> * `DEBUG` and `TRACE` are your best friends when something mysterious fails.

---
