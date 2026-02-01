# Architecture Diagram - OpenTofu Docker Infrastructure

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         AWS Cloud (OpenTofu)                        │
│                                                                      │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                        VPC (vpc module)                       │  │
│  │                   CIDR: 10.0.0.0/16                           │  │
│  │                                                               │  │
│  │  ┌────────────────────────────────────────────────────────┐   │  │
│  │  │         Public Subnet (public_subnet module)           │   │  │
│  │  │              CIDR: 10.0.1.0/24                         │   │  │
│  │  │                                                        │   │  │
│  │  │  ┌──────────────────────────────────────────────────┐  │   │  │
│  │  │  │  EC2 Instance (ec2 module)                       │  │   │  │
│  │  │  │  - Type: t3.micro (configurable)                 │  │   │  │
│  │  │  │  - Runs Docker & Docker Compose                │ │  │   │
│  │  │  │                                                  │  │  │  │
│  │  │  │  Docker Services:                                │ │  │  │
│  │  │  │  ┌─────────────┐  ┌──────────────┐             │ │  │  │
│  │  │  │  │   Node.js   │  │  PostgreSQL  │             │ │  │  │
│  │  │  │  │   Web App   │  │  Database    │             │ │  │  │
│  │  │  │  │  (port 8080)│  │              │             │ │  │  │
│  │  │  │  └─────────────┘  └──────────────┘             │ │  │  │
│  │  │  │                                                  │ │  │  │
│  │  │  │  ┌──────────────┐  ┌──────────────┐             │ │  │  │
│  │  │  │  │    Redis     │  │  Prometheus  │             │ │  │  │
│  │  │  │  │    Cache     │  │  Monitoring  │             │ │  │  │
│  │  │  │  │              │  │  (port 9090) │             │ │  │  │
│  │  │  │  └──────────────┘  └──────────────┘             │ │  │  │
│  │  │  │                                                  │ │  │  │
│  │  │  │  ┌──────────────┐                               │ │  │  │
│  │  │  │  │   Grafana    │                               │ │  │  │
│  │  │  │  │  Dashboard   │                               │ │  │  │
│  │  │  │  │  (port 3000) │                               │ │  │  │
│  │  │  │  └──────────────┘                               │ │  │  │
│  │  │  │                                                  │ │  │  │
│  │  │  └──────────────────────────────────────────────────┘ │  │  │
│  │  │              ↓                                         │  │  │
│  │  │  ┌──────────────────────────────────────────────────┐ │  │  │
│  │  │  │  Security Group (security_group module)         │ │  │  │
│  │  │  │  - Allow Inbound: 8080, 9090, 3000              │ │  │  │
│  │  │  │  - Allow Outbound: All                          │ │  │  │
│  │  │  │  - SSH: AWS Systems Manager Session Manager     │ │  │  │
│  │  │  └──────────────────────────────────────────────────┘ │  │  │
│  │  │                                                        │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │  │
│  │                                                           │  │  │
│  └───────────────────────────────────────────────────────────┘  │  │
│                                                                  │  │
│                     Internet Gateway (IGW)                       │  │
│                           ↓                                      │  │
└─────────────────────────────────────────────────────────────────┘  │
                            ↓
                   Internet/End Users
                   (Access via EC2 Public IP)
```

## Infrastructure as Code (IaC) Structure

```
opentofu-docker-infra/
│
├── main.tf                    # Root module that orchestrates all modules
├── providers.tf               # OpenTofu provider configuration (AWS)
├── variables.tf               # Input variables (vpc_cidr, instance_type, etc.)
├── outputs.tf                 # Output values
│
├── infra/                     # Infrastructure modules
│   ├── modules/
│   │   ├── vpc/               # VPC & Subnet creation
│   │   │   └── outputs: vpc_id, public_subnet_id
│   │   ├── security_group/    # Security group rules
│   │   │   └── outputs: security_group_id
│   │   └── ec2/               # EC2 instance provisioning
│   │       └── outputs: instance_id, public_ip
│   │
│   └── envs/                  # Environment-specific variables
│       ├── dev.tfvars
│       ├── staging.tfvars
│       └── prod.tfvars
│
├── docker/                    # Docker Compose setup
│   ├── docker-compose.yml     # Service definitions
│   ├── web/                   # Node.js web application
│   │   └── Dockerfile
│   ├── prometheus/            # Monitoring configuration
│   └── grafana/               # Dashboards & datasources
│
└── .github/
    └── workflows/             # CI/CD pipelines
        ├── tofu_validate.yml
        ├── tofu_deploy.yml
        ├── tofu_scan.yml
        ├── docker_build.yml
        └── docker_scans.yml
```

## Data Flow

```
Developer/CI/CD
      ↓
GitHub Actions Workflows
      ↓
OpenTofu (IaC)
      ├─→ Creates AWS Infrastructure
      │   ├─→ VPC
      │   ├─→ Public Subnet
      │   ├─→ EC2 Instance
      │   └─→ Security Group
      ↓
EC2 Instance
      ├─→ Docker Engine
      │   └─→ Docker Compose
      │       ├─→ Node.js Web App (port 8080)
      │       ├─→ PostgreSQL
      │       ├─→ Redis 
      │       ├─→ Prometheus (port 9090)
      │       └─→ Grafana (port 3000)
      ↓
Internet Gateway → Public IP
      ↓
End Users
```
