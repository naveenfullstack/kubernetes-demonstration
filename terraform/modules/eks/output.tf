output "cluster_id" {
  value = aws_eks_cluster.othm.id
}

output "cluster_name" {
  value = aws_eks_cluster.othm.name
}

output "cluster_arn" {
  value = aws_eks_cluster.othm.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.othm.endpoint
}

output "cluster_version" {
  value = aws_eks_cluster.othm.version
}

output "node_group_name" {
  value = aws_eks_node_group.othm.node_group_name
}

# output "eks_main_sg" {
#   value = aws_security_group.eks.id
# }

output "oidc_issuer_url" {
  value = aws_eks_cluster.othm.identity[0].oidc[0].issuer
}