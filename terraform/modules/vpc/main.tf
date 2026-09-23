# ---------------------------------------------------------
# VPC
# ---------------------------------------------------------

resource "aws_vpc" "othm_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = var.name
  }
}

# ---------------------------------------------------------
# Public Subnets
# ---------------------------------------------------------

resource "aws_subnet" "public_subnet_1_a" {
  vpc_id = aws_vpc.othm_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.name}-public-subnet-1-a-${var.environment}"
    environment = var.environment
  }
}