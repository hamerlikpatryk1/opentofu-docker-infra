output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
