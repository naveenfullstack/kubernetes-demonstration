# ---------------------------------------------------------
# VPC
# ---------------------------------------------------------

resource "aws_vpc" "jenkins_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "${var.name}-${var.environment}"
  }
}

# ---------------------------------------------------------
# Public Subnets
# ---------------------------------------------------------

resource "aws_subnet" "jenkins_public_subnet_1_a" {
  vpc_id = aws_vpc.jenkins_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.name}-public-subnet-1-a-${var.environment}"
    environment = var.environment
  }
}

# assign "public_route_table" to "public_subnet_1_a"

resource "aws_route_table_association" "jenkins_public_subnet_1_a" {
  subnet_id      = aws_subnet.jenkins_public_subnet_1_a.id
  route_table_id = aws_route_table.jenkins_public_route_table.id
}