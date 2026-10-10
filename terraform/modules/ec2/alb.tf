resource "aws_lb" "this" {
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