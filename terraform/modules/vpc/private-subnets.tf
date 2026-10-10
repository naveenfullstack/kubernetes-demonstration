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
  route_table_id = aws_route_table.private_route_table.id
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

# assign "private_route_table_b" to "private_subnet_1_b"

resource "aws_route_table_association" "private_subnet_1_b" {
  subnet_id      = aws_subnet.private_subnet_1_b.id
  route_table_id = aws_route_table.private_route_table_b.id
}