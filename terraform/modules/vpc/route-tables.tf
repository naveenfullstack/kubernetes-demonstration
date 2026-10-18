# Route Tables

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.othm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }

  tags = {
    Name        = "${var.name}-public-route-table-${var.environment}"
    Environment = var.environment
  }
}

# ---------------------------------------------------------
# Make Public Route Table the Main Route Table
# ---------------------------------------------------------

resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.othm_vpc.id
  route_table_id = aws_route_table.public_route_table.id
}

# ---------------------------------------------------------
# Private Route Table
# ---------------------------------------------------------

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.othm_vpc.id

  tags = {
    Name        = "${var.name}-private-route-table-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_a.id
}

# ---------------------------------------------------------

# Private Route Table Zone B

resource "aws_route_table" "private_route_table_b" {
  vpc_id = aws_vpc.othm_vpc.id

  tags = {
    Name        = "${var.name}-private-route-table-b-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_route" "private_route_b" {
  route_table_id         = aws_route_table.private_route_table_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_b.id
}