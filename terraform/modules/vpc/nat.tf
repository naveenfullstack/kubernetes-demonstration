# ---------------------------------------------------------
# NAT Gateway - AZ-A
# ---------------------------------------------------------

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_subnet_1_a.id

  tags = {
    Name        = "${var.name}-nat-gateway-a-${var.environment}"
    Environment = var.environment
  }

  depends_on = [
    var.gateway_id
  ]
}

# ---------------------------------------------------------
# NAT Gateway - AZ-B
# ---------------------------------------------------------

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_b.id
  subnet_id     = aws_subnet.public_subnet_1_b.id

  tags = {
    Name        = "${var.name}-nat-gateway-b-${var.environment}"
    Environment = var.environment
  }

  depends_on = [
    var.gateway_id
  ]
}