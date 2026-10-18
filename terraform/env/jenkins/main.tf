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
# Elastic IP
# ---------------------------------------------------------

resource "aws_eip" "jenkins_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-jenkins-eip"
  }
}