
---

## 🧩 **1️⃣ General format of a Terraform data source**

The **basic syntax** for a data source looks like this:

```hcl
data "<PROVIDER>_<DATA TYPE>" "<LOCAL NAME>" {
  <ARGUMENTS...>
}
```

---

### 📘 Example structure:

```hcl
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"  #search using the VPC’s Name tag.
    values = ["my-vpc"]  #only match VPCs whose Name tag = main-vpc
  }
}
```
> If you want to use a Data Source, you MUST THINK about the criteria to use in selecting that resource. 
> Its even in the name, data sources: You must specify the source of the data that you want. Specifying the source is done with the filter.

>  Its not always that you search. If you know the resource id, you can state it and then ask for the other properties that you want. For instance: 

```hcl
data "aws_instance" "foo" {
  instance_id = "i-instanceid"
}
```
andd then reference the image id with:

```
output "instance_image" {
  value = data.aws_instance.foo.image_id
}

```


---

## 🧱 **2️⃣ Breaking down each part**

| Component    | Description                                                                                     | Example                                                  |
| ------------ | ----------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `data`       | Keyword that declares a **read-only lookup**                                                    | Always starts a data block                               |
| `"aws_vpc"`  | The **data source type** — usually starts with provider name (`aws`, `azurerm`, `google`, etc.) | `"aws_vpc"` (AWS VPC data source)                        |
| `"selected"` | Your **local name** (how you’ll reference it elsewhere in code)                                 | `data.aws_vpc.selected`                                  |
| `{ ... }`    | Arguments or filters that define *what to look for*                                             | e.g., `filter { name = "tag:Name" values = ["my-vpc"] }` |

---

## 🔍 **3️⃣ How to reference it**

Once defined, you refer to its attributes using:

```
data.<PROVIDER>_<DATA TYPE>.<LOCAL NAME>.<ATTRIBUTE>
```

### Example:

```hcl
vpc_id = data.aws_vpc.selected.id
```

Here:

* `data` → keyword
* `aws_vpc` → data source type
* `selected` → local name
* `id` → attribute returned by AWS provider

---

## 💡 **4️⃣ Complete example with explanation**

```hcl
# -----------------------------
# Data Source: Get existing VPC
# -----------------------------
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["main-vpc"]
  }
}

# Use data source output in a resource
resource "aws_subnet" "example" {
  vpc_id     = data.aws_vpc.selected.id
  cidr_block = "10.0.1.0/24"
}
```

| Line                        | Explanation                                             |
| --------------------------- | ------------------------------------------------------- |
| `data "aws_vpc" "selected"` | Reads information about a VPC tagged “main-vpc”         |
| `filter { ... }`            | Defines lookup criteria                                 |
| `data.aws_vpc.selected.id`  | Gets the VPC’s ID for use in another resource           |
| `aws_subnet`                | Uses that ID to create a subnet inside the existing VPC |

---

## 🧾 **5️⃣ Generalized pattern**

You can think of a data source like a *function call*:

```
data.<provider>_<resource_type>.<name>.<attribute>
```

and it usually follows this shape:

```hcl
data "provider_resource" "label" {
  # Arguments / filters that help Terraform find the object
}

# Later usage
resource "something" "example" {
  property = data.provider_resource.label.attribute
}
```

---

## ⚙️ **6️⃣ Example with multiple filters**

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
```

→ You can use multiple `filter` blocks.
Each filter helps Terraform narrow down which resource to read.

---

## 🧭 **7️⃣ Summary Table**

| Element      | Meaning                  | Example                            |
| ------------ | ------------------------ | ---------------------------------- |
| `data`       | Declares a lookup block  | `data "aws_vpc" "example"`         |
| `"aws_vpc"`  | Provider + data type     | `"aws_s3_bucket"`, `"aws_ami"`     |
| `"example"`  | Local name for reference | `data.aws_vpc.example`             |
| `arguments`  | Lookup conditions        | `filter`, `id`, `name`, etc.       |
| `attributes` | Values returned          | `.id`, `.arn`, `.cidr_block`, etc. |

---

## ✅ **In one line**

> A Terraform `data` block is a **read-only lookup** that follows the format
> `data "<provider>_<type>" "<name>" { ... }`
> and is referenced as `data.<provider>_<type>.<name>.<attribute>`.

---

Excellent follow-up 👏 — you’re thinking like a real Terraform engineer now.

Yes — in AWS (and Terraform’s AWS provider), you can filter or look up existing resources using **many different criteria**, not just the Name tag.

Let’s explore this in a structured way 👇

---

## 🧩 1️⃣ FILTERING CRITERIA

Terraform’s **data sources** can look up existing AWS resources using the same kinds of filters that AWS APIs support — these are often things like:

* **Tags**
* **IDs**
* **CIDR blocks**
* **States**
* **Types**
* **Attributes specific to that resource**

---

## 💡 2️⃣ Common filtering criteria for AWS VPCs

If you’re using the `aws_vpc` data source, these are some examples of filters you can use:

| Filter Name       | What It Means                               | Example                                     |
| ----------------- | ------------------------------------------- | ------------------------------------------- |
| `vpc-id`          | Match a specific VPC ID                     | `values = ["vpc-0abcd1234ef567890"]`        |
| `cidr`            | Match a specific IPv4 CIDR block            | `values = ["10.0.0.0/16"]`                  |
| `is-default`      | Match the default VPC in the region         | `values = ["true"]`                         |
| `tag:<key>`       | Match a VPC tag                             | `name = "tag:Environment" values = ["dev"]` |
| `state`           | Match the VPC’s state                       | `values = ["available"]`                    |
| `dhcp-options-id` | Match VPCs using a certain DHCP options set | `values = ["dopt-123456"]`                  |

---

### 🧱 Example 1: Lookup by VPC ID

```hcl
data "aws_vpc" "by_id" {
  filter {
    name   = "vpc-id"
    values = ["vpc-0abcd1234ef567890"]
  }
}
```

→ Direct lookup of a known VPC ID.

---

### 🧱 Example 2: Lookup by CIDR block

```hcl
data "aws_vpc" "by_cidr" {
  filter {
    name   = "cidr"
    values = ["10.0.0.0/16"]
  }
}
```

→ Finds any VPC that uses the `10.0.0.0/16` network.

---

### 🧱 Example 3: Lookup by tag (Environment)

```hcl
data "aws_vpc" "dev" {
  filter {
    name   = "tag:Environment"
    values = ["development"]
  }
}
```

→ Finds VPCs tagged with `Environment = development`.

---

### 🧱 Example 4: Get the default VPC

```hcl
data "aws_vpc" "default" {
  default = true
}
```

→ This one doesn’t even need a filter; it’s a special built-in argument that returns the region’s default VPC.

---

## 🧭 3️⃣ Other resources have their own filters

Different data sources have **different filtering options**.

Here are examples from other AWS data sources:

| Resource             | Common Filters                                   | Example                                                         |
| -------------------- | ------------------------------------------------ | --------------------------------------------------------------- |
| `aws_subnet`         | `vpc-id`, `availability-zone`, `tag:Name`        | `filter { name = "availability-zone" values = ["us-east-1a"] }` |
| `aws_ami`            | `name`, `virtualization-type`, `owner-id`        | `filter { name = "name" values = ["ubuntu*"] }`                 |
| `aws_security_group` | `group-name`, `vpc-id`, `tag:Environment`        | `filter { name = "group-name" values = ["web-sg"] }`            |
| `aws_instance`       | `instance-type`, `availability-zone`, `tag:Role` | `filter { name = "tag:Role" values = ["bastion"] }`             |

---

## ✅ 4️⃣ Key takeaway

> Terraform’s `filter` block can use **any attribute** that AWS supports for that resource’s “Describe” API.

> If you want to use a Data Source, you MUST THINK about the criteria to use in selecting that resource. 
> Its even in the name, data sources: You must specify the source of the data that you want. Specifying the source is done with the filter.

---

