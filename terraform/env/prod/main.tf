terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

# ---------------------------------------------------------
# Modules
# ---------------------------------------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name        = "${var.name}-igw-${var.environment}"
    Environment = var.environment
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name        = var.name
  environment = var.environment
  gateway_id = aws_internet_gateway.igw.id
}

module "iam" {
  source = "../../modules/iam"

  name        = var.name
  environment = var.environment
}

module "ec2" {
  source = "../../modules/ec2"

  name        = var.name
  environment = var.environment
  vpc_id = module.vpc.vpc_id
  public_subnet_1_a = module.vpc.public_subnet_1_a_id
  public_subnet_1_b = module.vpc.public_subnet_1_b_id
  enable_deletion_protection = var.enable_deletion_protection
}

module "eks" {
  source = "../../modules/eks"

  name        = var.name
  environment = var.environment
  vpc_id = module.vpc.vpc_id
  private_subnet_1_a = module.vpc.private_subnet_1_a_id
  private_subnet_1_b = module.vpc.private_subnet_1_b_id
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn = module.iam.eks_node_role_arn
  eks_cluster_role_name = module.iam.eks_cluster_role_name
  eks_node_role_name = module.iam.eks_node_role_name
  node_instance_types = var.node_instance_types
  node_min_size = var.node_min_size
  node_desired_size = var.node_desired_size
  node_max_size = var.node_max_size
  aws_profile_id = var.aws_profile_id
}