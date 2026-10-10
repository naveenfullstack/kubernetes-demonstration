# =========================================================
# EKS SECURITY GROUP
# =========================================================

resource "aws_security_group" "eks" {
  name        = "${var.name}-eks-sg-${var.environment}"
  description = "Security group for EKS cluster and worker nodes"
  vpc_id      = var.vpc_id

  # Allow communication between resources using this SG.
  # Required for cluster and worker-node communication.

  ingress {
    description = "Allow internal EKS cluster and node communication"
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self = true
  }

  # Allow outbound traffic for AWS APIs

  egress {
    description = "Allow outbound traffic"
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-eks-sg-${var.environment}"
    Environment = var.environment
  }
}