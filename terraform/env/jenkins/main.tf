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

#---------------------------------------------------------
# Internet Gateway
#---------------------------------------------------------

resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name        = "${var.name}-igw-${var.environment}"
    Environment = var.environment
  }
}

# ---------------------------------------------------------
# Elastic IP
# ---------------------------------------------------------

resource "aws_eip" "jenkins_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-jenkins-eip"
  }
}