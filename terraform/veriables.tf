variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to deploy resources"
}

variable "aws_account_id" {
  type        = string
  default     = "125022369875"
  description = "AWS account ID"
}

variable envirement {
  type        = string
  default     = "dev"
  description = "environment"
}

variable name {
  type        = string
  default     = "othm"
  description = "description"
}

variable instance_type {
  type        = string
  default     = "t3.medium"
  description = "description"
}




 