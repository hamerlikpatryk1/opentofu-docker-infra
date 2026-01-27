# EC2 Module

Creates an EC2 instance in the provided subnet and security group.

## Example

```hcl
module "ec2" {
  source = "../modules/ec2"

  instance_type     = "t3.micro"
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_group.security_group_id
}
<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
