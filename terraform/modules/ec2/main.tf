resource "aws_instance" "RocketDexK8s_Frontend" {
  count                  = var.RocketDexK8s_Frontend_count
  ami                    = var.ami_id
  instance_type          = var.RocketDexK8s_Frontend_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.RocketDexK8s_Frontend_sg.id]
  subnet_id              = var.public_subnet_ids[count.index % length(var.public_subnet_ids)]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  user_data              = file("${path.module}/user_data.sh")

  tags = {
    Name = "RocketDexK8s-Frontend-${count.index + 1}"
  }
}