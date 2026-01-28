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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.47.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2"></a> [ec2](#module\_ec2) | ./infra/modules/ec2 | n/a |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | ./infra/modules/security_group | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./infra/modules/vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type | `string` | `"t3.micro"` | no |
| <a name="input_public_subnet_cidr"></a> [public\_subnet\_cidr](#input\_public\_subnet\_cidr) | n/a | `string` | `"10.0.1.0/24"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"eu-north-1"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | n/a | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_public_ip"></a> [ec2\_public\_ip](#output\_ec2\_public\_ip) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
<!-- END_TF_DOCS -->
