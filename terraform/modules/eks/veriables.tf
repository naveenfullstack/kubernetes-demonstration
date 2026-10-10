variable name {
  type        = string
}

variable environment {
  type        = string
}

variable vpc_id {
  type        = string
}

variable private_subnet_1_a {
  type        = string
}

variable private_subnet_1_b {
  type        = string
}

variable eks_cluster_role_arn {
  type        = string
}

variable eks_node_role_arn {
  type        = string
}

variable eks_cluster_role_name {
  type        = string
}

variable eks_node_role_name {
  type        = string
}

variable "kubernetes_version" {
  type    = string
  default = "1.36"
}

variable "node_instance_types" {
  type    = list(string)
}

variable "node_min_size" {
  type    = number
}

variable "node_desired_size" {
  type    = number
}

variable "node_max_size" {
  type    = number
}

variable "aws_profile_id" {
  type    = string
}