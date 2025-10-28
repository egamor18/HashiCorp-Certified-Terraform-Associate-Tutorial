
## TERRAFORM GRAPH

---

## 🧭 1. **What is `terraform graph`?**

`terraform graph` is a **visualization tool** that shows the **dependency relationships** between all resources in your Terraform configuration.

Terraform builds a **dependency graph** internally every time it plans or applies — and this command simply **outputs that graph**.

It’s especially helpful when:

* Debugging why Terraform creates resources in a certain order
* Understanding complex dependencies
* Visualizing modules or networks of resources

---

## ⚙️ 2. **Basic Command**

```bash
terraform graph
```

This outputs a graph in **DOT format** (used by Graphviz).

Example output:

```
digraph {
  compound = "true"
  newrank = "true"
  subgraph "root" {
    aws_vpc.main [label="aws_vpc.main"];
    aws_subnet.public [label="aws_subnet.public"];
    aws_instance.web [label="aws_instance.web"];
    aws_instance.web -> aws_subnet.public;
    aws_subnet.public -> aws_vpc.main;
  }
}
```

That means:

* `aws_vpc.main` must be created first,
* then `aws_subnet.public`,
* then `aws_instance.web` which depends on the subnet.

---

## 🎨 3. **Visualize It Using Graphviz**

The DOT output is hard to read in plain text — so you use **Graphviz** to render it as an image.

### 🧩 Step 1 — Install Graphviz

On Ubuntu:

```bash
sudo apt install graphviz
```

On macOS:

```bash
brew install graphviz
```

---

### 🧩 Step 2 — Generate an Image

You can pipe Terraform’s graph output directly into Graphviz to create a PNG file:

```bash
terraform graph | dot -Tpng > graph.png
```

Then open it:

```bash
xdg-open graph.png   # Linux
open graph.png       # macOS
```

You’ll see a visual diagram like:

```
VPC → Subnet → Instance
```

Each arrow shows a dependency Terraform enforces.

---

## 🧱 4. **Graph Types / Options**

Terraform lets you visualize **different stages** of the graph.

| Command                         | Description                                    |
| ------------------------------- | ---------------------------------------------- |
| `terraform graph`               | Shows the default dependency graph             |
| `terraform graph -type=plan`    | Shows graph of planned actions                 |
| `terraform graph -type=apply`   | Shows dependencies for the apply step          |
| `terraform graph -type=destroy` | Shows destruction order                        |
| `terraform graph -type=input`   | Shows how input variables connect to resources |

Example:

```bash
terraform graph -type=plan | dot -Tsvg > plan.svg
```

---

## 🧩 5. **Reading the Graph**

* **Rectangles (nodes)** = resources
* **Arrows (edges)** = dependencies
* **Dashed lines** = implicit dependencies (e.g. outputs, variables)
* **Solid lines** = explicit dependencies (via `depends_on` or resource references)

---

## 🧠 6. **Why It’s Useful**

✅ Understand the **order of creation and destruction**
✅ Debug **“dependency cycle”** or **“resource not ready”** errors
✅ Communicate infrastructure design visually
✅ Audit complex configurations

---

## 🧩 7. **Example**

Given this Terraform code:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_instance" "web" {
  subnet_id = aws_subnet.public.id
  ami       = "ami-123456"
  instance_type = "t2.micro"
}
```

The dependency graph will look like this:

```
aws_vpc.main
  ↓
aws_subnet.public
  ↓
aws_instance.web
```

Terraform uses this graph internally to ensure:

1. The VPC is created first
2. Then the Subnet
3. Then the EC2 instance

---
