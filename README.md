# OpenTofu Docker Infrastructure

Infrastructure as Code demo using OpenTofu and Docker Compose with multi-environment setup (workspaces), CI/CD pipeline and local monitoring stack.

## Overview

This repository defines AWS infrastructure using OpenTofu and modular structure:

- **VPC**: creates a VPC and a public subnet.
- **Security Group**: creates a security group for EC2.
- **EC2**: creates an EC2 instance inside the VPC.

## Example

```hcl
module "vpc" {
  source = "./infra/modules/vpc"

  vpc_cidr          = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
}

module "security_group" {
  source = "./infra/modules/security_group"

  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./infra/modules/ec2"

  instance_type     = "t3.micro"
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_group.security_group_id
}
```
<!-- BEGIN_TF_DOCS -->
{{ .Content }}
<!-- END_TF_DOCS -->
