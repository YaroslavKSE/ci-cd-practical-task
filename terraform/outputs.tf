output "frontend_public_ip" {
  value = aws_instance.RocketDexK8s_Frontend[0].public_ip
}

output "frontend_instance_id" {
  value = module.ec2.frontend_instance_id
}