# Security Group Module

Creates a security group inside the provided VPC.

## Example

```hcl
module "security_group" {
  source = "../modules/security_group"

  vpc_id = module.vpc.vpc_id
}
<!-- BEGIN_TF_DOCS --> <!-- END_TF_DOCS -->
