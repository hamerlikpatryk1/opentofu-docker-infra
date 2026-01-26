data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_instance" "first_ecs_node" {
  ami = data.aws_ssm_parameter.ecs_ami.value
  instance_type = var.instance_type
  subnet_id = var.subnet_id
}