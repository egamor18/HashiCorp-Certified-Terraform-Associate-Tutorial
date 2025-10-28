## PINNING MODULE VERSION
---

# Consul Module Example

This repository demonstrates using the **HashiCorp Consul AWS module** with Terraform, focusing on module versioning and caching behavior.

---

## **Module Configuration**

```hcl
module "consul" {
  source  = "hashicorp/consul/aws"
  version = "0.9.2"
  servers = 3
}
```

* **source**: Terraform Registry path to the Consul module
* **version**: Module version to use
* **servers**: Number of Consul servers to deploy

---

## **Lessons / Steps**

1. **Run with the pinned version**

```bash
terraform init
```

* Terraform downloads **version 0.9.2** from the registry.
* This ensures reproducible deployments.

2. **Comment out the version and rerun `terraform init`**

```hcl
# version = "0.9.2"
```

```bash
terraform init
```

* **Result:** Terraform **does not download a newer version**.
* The previously downloaded version **remains cached** locally.

3. **Upgrade to the latest module version**

```bash
terraform init -upgrade
```

* Terraform downloads the **latest version** of the module from the registry.
* This ensures you can adopt new features or fixes when needed.

---

### ✅ **Key Takeaways**

* Pinning a module version ensures **stable, predictable deployments**.
* Terraform caches downloaded modules in `.terraform/modules`.
* Use `terraform init -upgrade` to fetch newer versions when desired.

---
