# =========================================================
# EKS MANAGED NODE GROUP
# =========================================================

resource "aws_eks_node_group" "othm" {
  cluster_name = aws_eks_cluster.othm.name

  node_group_name = "${var.name}-node-group-${var.environment}"

  node_role_arn = var.eks_node_role_arn

  subnet_ids = [
      var.private_subnet_1_a,
      var.private_subnet_1_b
    ]

  instance_types = var.node_instance_types

  ami_type = "AL2023_x86_64_STANDARD"

  capacity_type = "ON_DEMAND"

  scaling_config {
    min_size     = var.node_min_size
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name        = "${var.name}-node-group-${var.environment}"
    Environment = var.environment
  }

  depends_on = [
    aws_eks_cluster.othm
  ]
}