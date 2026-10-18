# =========================================================
# ALB TARGET GROUP FOR EKS PODS
# =========================================================

resource "aws_lb_target_group" "eks" {
  name        = "${var.name}-eks-tg-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = "traffic-port"
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "${var.name}-eks-tg-${var.environment}"
    Environment = var.environment
  }
}