module "vpc" {
  source = "./infra/modules/vpc"

  vpc_cidr = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

module "ec2" {
  source = "./infra/modules/ec2"

  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnet_id
}
