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
# Internet Gateway
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
}

module "route-tables" {
  source = "../../modules/route-tables"

  environment = var.environment
  vpc_id = module.vpc.vpc_id
  gateway_id = aws_internet_gateway.igw.id
  name        = var.name
  public_subnet_1_a = module.vpc.public_subnet_1_a_id
}

module "iam" {
  source = "../../modules/iam"

  name        = var.name
  environment = var.environment
}

module "sg" {
  source = "../../modules/sg"

  name        = var.name
  environment = var.environment
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "../../modules/ec2"

  name        = var.name
  environment = var.environment
  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnet_1_a_id
  jenkins_sg = module.sg.jenkins_security_group
  iam_role = module.iam.iam_role_name
}