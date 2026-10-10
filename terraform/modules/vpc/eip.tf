# ---------------------------------------------------------
# Elastic IP - NAT Gateway AZ-A
# ---------------------------------------------------------

resource "aws_eip" "nat_a" {
  domain = "vpc"

  tags = {
    Name        = "${var.name}-nat-eip-a-${var.environment}"
    Environment = var.environment
  }
}

# ---------------------------------------------------------
# Elastic IP - NAT Gateway AZ-B
# ---------------------------------------------------------

resource "aws_eip" "nat_b" {
  domain = "vpc"

  tags = {
    Name        = "${var.name}-nat-eip-b-${var.environment}"
    Environment = var.environment
  }
}