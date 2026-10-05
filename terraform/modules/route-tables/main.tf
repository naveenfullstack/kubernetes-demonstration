# Route Tables

resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

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
  vpc_id         = var.vpc_id
  route_table_id = aws_route_table.public_route_table.id
}

# ---------------------------------------------------------
# Private Route Table
# ---------------------------------------------------------

resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.name}-private-route-table-${var.environment}"
    Environment = var.environment
  }
}