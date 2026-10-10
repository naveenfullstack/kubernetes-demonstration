# =========================================================
# EKS CLUSTER
# =========================================================

resource "aws_eks_cluster" "othm" {
  name = "${var.name}-eks-${var.environment}"

  version = var.kubernetes_version

  role_arn = var.eks_cluster_role_arn

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    subnet_ids = [
      var.private_subnet_1_a,
      var.private_subnet_1_b
    ]

    security_group_ids = [
      aws_security_group.eks.id
    ]

    endpoint_private_access = true
    endpoint_public_access  = false
  }

  tags = {
    Name        = "${var.name}-eks-${var.environment}"
    Environment = var.environment
  }
} 

# =========================================================
# EKS ADMIN ACCESS ENTRY
# =========================================================

resource "aws_eks_access_entry" "admin" {
  cluster_name  = aws_eks_cluster.othm.name
  principal_arn = "arn:aws:iam::${var.aws_profile_id}:user/terraform"

  type = "STANDARD"

  tags = {
    Name        = "${var.name}-eks-admin-access-${var.environment}"
    Environment = var.environment
  }
}


# =========================================================
# EKS ADMIN ACCESS POLICY
# =========================================================

resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = aws_eks_cluster.othm.name
  principal_arn = aws_eks_access_entry.admin.principal_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}