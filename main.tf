module "ec2" {
  source = "./infra/modules/ec2"

  instance_type = var.instance_type
}
