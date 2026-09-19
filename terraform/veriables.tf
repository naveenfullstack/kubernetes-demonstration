variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to deploy resources"
}

variable "instance_name" {
  type        = string
  default     = "fitwin-be-verticle-scale"
  description = "Name of EC2 instance"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "Type of EC2 instance"
}

variable "aws_account_id" {
  type        = string
  default     = "125022369875"
  description = "AWS account ID"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment name"
}
 