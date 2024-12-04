output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.rocketdex.dns_name # Changed from rocketdex-alb-sg to rocketdex
}

output "alb_sg_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.rocketdex.arn
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer"
  value       = aws_lb.rocketdex.zone_id
}