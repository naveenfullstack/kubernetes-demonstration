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
  route_table_id = aws_route_table.public_route_table.id
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
  route_table_id = aws_route_table.public_route_table.id
}