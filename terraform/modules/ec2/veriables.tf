variable name {
  type        = string
}

variable environment {
  type        = string
}

variable vpc_id {
    type = string
}

variable public_subnet_1_a {
  type        = string
}

variable public_subnet_1_b {
  type        = string
}

variable "enable_deletion_protection" {
  description = "Enable ALB deletion protection"
  type        = bool
}