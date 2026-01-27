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
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.47 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.47 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| aws_security_group.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security Group ID for EC2 |
<!-- END_TF_DOCS -->
