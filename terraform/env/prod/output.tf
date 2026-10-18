# output "eks_sg" {
#    value = module.eks.eks_main_sg
# }

output "eks_cluster_id" {
   value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
   value = module.eks.cluster_endpoint
}

output "vpc_id" {
   value = module.vpc.vpc_id
}

output "public_subnet_1_a_id" {
  value       = module.vpc.public_subnet_1_a_id
}

output "public_subnet_1_b_id" {
  value       = module.vpc.public_subnet_1_b_id
}

output "lb_controller_role_arn" {
   value = module.iam.lb_controller_role_arn
}
