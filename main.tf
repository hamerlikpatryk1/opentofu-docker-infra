module "vpc" {
  source = "./infra/modules/vpc"

  vpc_cidr = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

module "ec2" {
  source = "./infra/modules/ec2"

  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnet_id
  security_group_id = module.security_group.security_group_id
}

module "security_group" {
  source = "./infra/modules/security_group"

  vpc_id = module.vpc.vpc_id
}
#test