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

# assign "public_route_table" to "public_subnet_1_a"

resource "aws_route_table_association" "public_subnet_1_a" {
  subnet_id      = aws_subnet.public_subnet_1_a.id
  route_table_id = var.public_route_table
}

# ---------------------------------------------------------

resource "aws_subnet" "public_subnet_1_b" {
  vpc_id = aws_vpc.othm_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.name}-public-subnet-1-b-${var.environment}"
    environment = var.environment
  }
}

# assign "public_route_table" to "public_subnet_1_b"

resource "aws_route_table_association" "public_subnet_1_b" {
  subnet_id      = aws_subnet.public_subnet_1_b.id
  route_table_id = var.public_route_table
}

# ---------------------------------------------------------

# ---------------------------------------------------------
# Private Subnets
# ---------------------------------------------------------

resource "aws_subnet" "private_subnet_1_a" {
  vpc_id = aws_vpc.othm_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.name}-private-subnet-1-a-${var.environment}"
    environment = var.environment
  }
}

# assign "private_route_table" to "private_subnet_1_a"

resource "aws_route_table_association" "private_subnet_1_a" {
  subnet_id      = aws_subnet.private_subnet_1_a.id
  route_table_id = var.private_route_table
}

# ---------------------------------------------------------

# Private Subnet B

resource "aws_subnet" "private_subnet_1_b" {
  vpc_id = aws_vpc.othm_vpc.id

  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.name}-private-subnet-1-b-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private_subnet_1_b" {
  subnet_id      = aws_subnet.private_subnet_1_b.id
  route_table_id = var.private_route_table
}