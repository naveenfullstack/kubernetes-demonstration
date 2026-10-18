resource "aws_lb" "alb" {
  name               = "${var.name}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    var.public_subnet_1_a,
    var.public_subnet_1_b
  ]

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Name        = "${var.name}-alb-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks.arn
  }

  tags = {
    Name        = "${var.name}-http-listener-${var.environment}"
    Environment = var.environment
  }
}

# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = 443
#   protocol          = "HTTPS"

#   certificate_arn = var.alb_certificate_arn

#   ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.eks.arn
#   }

#   tags = {
#     Name        = "${var.name}-https-listener-${var.environment}"
#     Environment = var.environment
#   }
# }