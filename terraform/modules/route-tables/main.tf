# Route Tables

resource "aws_route_table" "jenkins_route_table_public" {
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

# "assign" the route table to the subnet

resource "aws_route_table_association" "jenkins_subnet_public_1a" {
  subnet_id      = var.public_subnet_1_a
  route_table_id = aws_route_table.jenkins_route_table_public.id
}