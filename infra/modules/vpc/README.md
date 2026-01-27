# VPC Module

Creates a VPC with a public subnet.

## Example

```hcl
module "vpc" {
  source = "../modules/vpc"

  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
}
<!-- BEGIN_TF_DOCS --> <!-- END_TF_DOCS -->
