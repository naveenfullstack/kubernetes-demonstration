variable "aws_region" {
  type        = string
}

variable environment {
  type        = string
}

variable name {
  type        = string
}

variable aws_profile {
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

variable "enable_deletion_protection" {
  type        = bool
}





 