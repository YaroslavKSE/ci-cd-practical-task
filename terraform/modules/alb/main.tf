resource "aws_security_group" "alb" {
  name        = "rocketdex-alb-sg"
  description = "Security group for rocketdex ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rocketdex ALB Security Group"
  }
}

resource "aws_lb" "rocketdex" {
  name               = "rocketdex-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "rocketdex ALB"
  }
}

resource "aws_lb_target_group" "rocketdex" {
  name     = "rocketdex-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}


resource "aws_lb_listener" "rocketdex_https" {
  load_balancer_arn = aws_lb.rocketdex.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rocketdex.arn
  }
}

# HTTP to HTTPS Redirect
resource "aws_lb_listener" "rocketdex_http" {
  load_balancer_arn = aws_lb.rocketdex.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group_attachment" "rocketdex" {
  target_group_arn = aws_lb_target_group.rocketdex.arn
  target_id        = var.instance_id
  port             = 80
}