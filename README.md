# Infrastructure as Service with Docker and OpenTofu

## Description

A comprehensive Infrastructure as Code demo using OpenTofu and Docker Compose with multi-environment setup, CI/CD pipeline, and local monitoring stack.

---

## Table of Contents

- [Overview](#)
- [Project Structure](#)
- [Prerequisites](#)
- [Quick Start](#)
- [Environments](#)
- [Docker Build](#docker-build)
- [Monitoring](#monitoring)
  - [Prometheus](#prometheus)
  - [Grafana](#grafana)
- [CI/CD Pipeline](#)
- [Testing](#)
- [License](#)
  
---

## Overview

This project demonstrates best practices for Infrastructure as Code by:

Multi-environment setup using OpenTofu workspaces (dev, staging, prod)
Modular infrastructure with reusable Terraform modules
Docker Compose for local development and monitoring stack
Automated CI/CD with GitHub Actions
Infrastructure scanning and validation
Automated documentation generation with Terradocs
Comprehensive testing with Terratest in Go

---

## Project Structure

```bash
.
├── infra/                          # OpenTofu/Terraform code
│   ├── envs/                       # Environment variables
│   │   ├── dev.tfvars
│   │   ├── staging.tfvars
│   │   └── prod.tfvars
│   └── modules/                    # Reusable modules
│       ├── vpc/                    # VPC configuration
│       ├── security_group/         # Security group rules
│       └── ec2/                    # EC2 instances
├── docker/                         # Docker Compose setup
│   ├── docker-compose.yml          # Services definition
│   ├── prometheus/                 # Prometheus config
│   ├── grafana/                    # Grafana dashboards
│   └── web/                        # Sample web application
├── tests/                          # Infrastructure tests
│   └── infra_test.go               # Go tests
├── .github/workflows/              # CI/CD pipelines
│   ├── tofu_deploy.yml
│   ├── tofu_validate.yml
│   ├── tofu_scan.yml
│   ├── docker_build.yml
│   └── docker_scans.yml
├── main.tf                         # Root configuration
├── providers.tf                    # Provider configuration
├── variables.tf                    # Input variables
├── outputs.tf                      # Output values
└── versions.tf                     # Version constraints
```

---

## Prerequisites
OpenTofu >= 1.6.0
Terraform CLI (for compatibility)
Docker & Docker Compose
Go >= 1.19 (for testing)
AWS Account with appropriate credentials
kubectl (for Kubernetes operations, if applicable)

---

## Quick Start

1. Clone the Repository
```bash
git clone https://github.com/hamerlikpatryk1/opentofu-docker-infra.git
cd opentofu-docker-infra
```
2. Configure AWS Credentials in GH secrets
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
```
3. Initialize OpenTofu
```bash
tofu init
```
4. Select Environment
```bash
tofu workspace select dev   # or staging/prod
```
5. Plan Infrastructure
```bash
tofu plan -var-file="infra/envs/dev.tfvars"
```
6. Apply Changes
```bash
tofu apply -var-file="infra/envs/dev.tfvars"
```

---

## Environments
This project supports three environments with separate state management:

### Development (dev)
* Minimal resources for testing
* Configuration: infra/envs/dev.tfvars

### Staging (staging)
* Production-like setup for validation
* Configuration: infra/envs/staging.tfvars

### Production (prod)
* Full production deployment
* Cnfiguration: infra/envs/prod.tfvars

### Switch between environments:
```bash
tofu workspace list
tofu workspace select <environment>
```

---

## Monitoring
The project includes a complete monitoring stack with Docker Compose:

Start Monitoring Stack
```bash
cd docker
docker-compose up -d
```
### Access Services
* Prometheus: http://localhost:9090
* Grafana: http://localhost:3000 (default: admin/admin)
* Web Application: http://localhost:3000

### Configuration Files
* docker/prometheus/prometheus.yml - Prometheus scrape configs
* docker/grafana/provisioning/ - Grafana dashboards and datasources

---

## CI/CD Pipeline
Automated workflows run on every push and pull request:

### Workflows
* tofu_validate.yml - Syntax and format validation
* tofu_scan.yml - Security scanning (Tfsec, Checkov)
* tofu_deploy.yml - Infrastructure deployment
* docker_build.yml - Docker image build
* docker_scans.yml - Container security scanning
* docs.yml - Auto-generated documentation

---

## Testing
Run infrastructure tests with Go:
```bash
cd tests
go test -v
```
Test file: tests/infra_test.go

---

## Modules

VPC Module
* Location: infra/modules/vpc
* Manages Virtual Private Cloud setup
* Documentation

Security Group Module
* Location: infra/modules/security_group
* Configures security group rules
* Documentation

EC2 Module
* Location: infra/modules/ec2
* Manages EC2 instances
* Documentation

## Common Commands
```bash
# Plan changes
tofu plan -var-file="infra/envs/dev.tfvars"

# Apply changes
tofu apply -var-file="infra/envs/dev.tfvars"

# Destroy infrastructure
tofu destroy -var-file="infra/envs/dev.tfvars"

# Format code
tofu fmt -recursive

# Validate syntax
tofu validate

# Generate documentation
terraform-docs markdown . > docs/MODULES.md

# Show outputs
tofu output
```

---

## Security
* All infrastructure is scanned with Trivy
* Docker images are scanned in the CI/CD pipeline
* Secrets are managed via GitHub Actions secrets
* State files are protected and backed up

---

## License
This project is licensed under the MIT License - see the LICENSE file for details.

---

## Author
Created by hamerlikpatryk1


---
##Docker Build

To build the image locally:

docker build -t app:latest ./docker/web

To build full stack

docker-compose -f ./docker/docker-compose.yml up -d

To stop stack

docker-compose -f docker/docker-compose.yml down

##Monitoring

The stack includes Prometheus and Grafana.
##Prometheus

    Port: 9090
    Configuration in docker/prometheus/prometheus.yml
    Data collected from the web container (endpoint /metrics)

##Grafana

    Port: 3000
    Provisioning:
        Dashboards: docker/grafana/provisioning/dashboards/
        Datasource: docker/grafana/provisioning/datasource/
    Data from Prometheus
    Default login/password: admin/admin (change in prod!)

