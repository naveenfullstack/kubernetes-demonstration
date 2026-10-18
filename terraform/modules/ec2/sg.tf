resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-sg-${var.environment}"
  description = "Security group for the EKS application load balancer"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow outbound traffic to EKS workloads"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-alb-sg-${var.environment}"
    Environment = var.environment
  }
}

# HTTP

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTP traffic to the ALB"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_ipv4   = "0.0.0.0/0"
}

# HTTPS

# resource "aws_vpc_security_group_ingress_rule" "alb_https" {
#   security_group_id = aws_security_group.alb.id

#   description = "Allow HTTPS traffic to the ALB"
#   ip_protocol = "tcp"
#   from_port   = 443
#   to_port     = 443
#   cidr_ipv4   = "0.0.0.0/0"
# }