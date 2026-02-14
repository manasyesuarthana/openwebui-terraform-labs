# Terraform Labs — Deploy OpenWebUI on AWS, GCP & Azure

<img src="./banner.jpg" alt="Terraform Labs Banner" width="100%">

<br />
A hands-on Infrastructure as Code (IaC) learning project for deploying [Open WebUI](https://github.com/open-webui/open-webui) across multiple cloud providers using [Terraform](https://www.terraform.io/). The goal is to practice and solidify Terraform skills by provisioning real cloud infrastructure from scratch — networking, compute, security, and application deployment — all defined as code.

> **Credits:** Inspired by [Nicholas Jackson's](https://github.com/nicholasjackson) excellent Terraform guide.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Directory Structure](#directory-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Module 1 — Terraform Basics (Local Docker)](#module-1--terraform-basics-local-docker)
  - [Module 2 — AWS Deployment](#module-2--aws-deployment)
  - [Module 3 — GCP Deployment (Planned)](#module-3--gcp-deployment-planned)
  - [Module 4 — Azure Deployment (Planned)](#module-4--azure-deployment-planned)
- [Terraform Workflow Cheat Sheet](#terraform-workflow-cheat-sheet)

---

## Project Overview

This repository is structured as a progressive learning path:

| Module | Provider | Description | Status |
|--------|----------|-------------|--------|
| `basics/` | Docker (local) | Learn the core Terraform workflow (`init` → `plan` → `apply` → `destroy`) without needing a cloud account. Deploys a HashiCorp Vault container locally. | Complete |
| `aws/` | AWS | Deploy Open WebUI with Ollama on an EC2 Spot Instance inside a custom VPC, complete with networking, security groups, and automated provisioning. | Complete |
| `gcp/` | Google Cloud | Deploy Open WebUI on GCP Compute Engine. | Planned |
| `azure/` | Azure | Deploy Open WebUI on Azure Virtual Machines. | Planned |

### What is Open WebUI?

[Open WebUI](https://github.com/open-webui/open-webui) is a self-hosted, feature-rich web interface for running large language models (LLMs) locally. It ships with [Ollama](https://ollama.ai/) integration, enabling you to run models like Llama, Mistral, and more — all from a browser. This project automates the entire deployment of Open WebUI + Ollama on cloud VMs using Terraform.

---

## Directory Structure

```
basic-terraform-labs/
├── README.md                    
├── .gitignore                   
├── .envrc                      
│
├── basics/                      
│   ├── README.md                 
│   ├── main.tf                  
│   └── docker.tf                
│
└── aws/                         
    ├── main.tf                   
    ├── vm.tf                     
    ├── output.tf                 
    └── scripts/
        └── provision_basic.sh   
```

---

## Prerequisites


| Tool | Version | Purpose |
|------|---------|---------|
| [Terraform](https://developer.hashicorp.com/terraform/install) | ≥ 1.0 | Infrastructure as Code engine |
| [Git](https://git-scm.com/) | Any | Clone the repository |
| [direnv](https://direnv.net/) | Any | (Optional) Auto-load environment variables from `.envrc` |

---

## Getting Started

### Module 1 — Terraform Basics (Local Docker)

> **Goal:** Learn the core Terraform lifecycle without touching the cloud.

This module uses the [kreuzwerker/docker](https://registry.terraform.io/providers/kreuzwerker/docker/latest) provider to manage Docker resources locally. It pulls and runs a [HashiCorp Vault](https://www.vaultproject.io/) container — a great way to see Terraform in action.

```bash
# 1. navigate to the basics module
cd basics/

# 2. initialize terraform (downloads the Docker provider)
terraform init

# 3. preview what will be created
terraform plan

# 4. apply the configuration (creates the container)
terraform apply

# 5. verify vault is running
curl http://localhost:8200/v1/sys/health
# or open http://localhost:8200 in your browser

# 6. tear everything down when done
terraform destroy
```

#### What Gets Created

| Resource | Type | Details |
|----------|------|---------|
| `docker_image.vault` | Docker Image | `hashicorp/vault:1.17.1` |
| `docker_container.vault` | Docker Container | Named `terraform-basics-vault`, port `8200:8200` |

---

### Module 2 — AWS Deployment

> **Goal:** Deploy a fully functional Open WebUI instance on AWS with proper networking.

#### Step 1: Configure SSH Key

Before applying, you need to provide a path to your **public** SSH key in `aws/vm.tf`:

```hcl
resource "aws_key_pair" "open_web_ui" {
  key_name   = "open_web_ui"
  public_key = file("~/.ssh/id_rsa.pub")  # ← Update this path
}
```

#### Step 2: Deploy

```bash
# 1. navigate to the AWS module
cd aws/

# 2. initialize terraform (downloads AWS, terracurl, and random providers)
terraform init

# 3. preview the infrastructure plan
terraform plan

# 4. apply (type 'yes' to confirm)
terraform apply

# 5. wait for deployment to complete
#  terraform will wait for the spot instance fulfillment and
#  terracurl will poll the instance until Open WebUI responds with HTTP 200.

# 6. retrieve the outputs
terraform output public_ip   # the public IP of your instance
terraform output -raw password  # the auto-generated admin password
```

#### Step 3: Access Open WebUI

Once deployment is complete:

1. Open `http://<public_ip>` in your browser
2. Log in with:
   - **Email:** `admin@demo.gs` (default, configurable via `open_webui_user` variable)
   - **Password:** The value from `terraform output -raw password`

#### Step 4: Clean Up

```bash
# destroy all resources to stop incurring costs
terraform destroy
```

#### Customizing the Deployment

| Variable | Default | Description |
|----------|---------|-------------|
| `open_webui_user` | `admin@demo.gs` | Admin email/username for Open WebUI |

Override at apply time:

```bash
terraform apply -var="open_webui_user=myemail@example.com"
```

---

### Module 3 — GCP Deployment (Planned)

> Coming soon. Will deploy Open WebUI on Google Compute Engine using the `google` provider.

### Module 4 — Azure Deployment (Planned)

> Coming soon. Will deploy Open WebUI on Azure Virtual Machines using the `azurerm` provider.

---

## Terraform Workflow Cheat Sheet

The four core commands you'll use throughout this project:

```bash
# 1. INIT — Download providers and initialize the working directory
terraform init

# 2. PLAN — Preview changes without applying them
terraform plan

# 3. APPLY — Create/update infrastructure
terraform apply

# 4. DESTROY — Tear down all managed resources
terraform destroy
```

### Useful Additional Commands

```bash
# format all .tf files
terraform fmt

# validate configuration syntax
terraform validate

# show current state
terraform show

# list all resources in state
terraform state list

# view a specific output (including sensitive ones)
terraform output -raw <output_name>

# refresh state to match real infrastructure
terraform refresh
```

---

**This project is for personal learning and educational purposes.**
