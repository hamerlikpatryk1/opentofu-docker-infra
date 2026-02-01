data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

resource "aws_instance" "this" {
  ami                  = data.aws_ssm_parameter.ecs_ami.value
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    delete_on_termination = false
    encrypted             = true
  }
}
