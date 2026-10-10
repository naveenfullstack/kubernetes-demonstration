#---------------------------------------------------------
# Route Tables
#---------------------------------------------------------

resource "aws_route_table" "jenkins_public_route_table" {
  vpc_id = aws_vpc.jenkins_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_igw.id
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
  vpc_id         = aws_vpc.jenkins_vpc.id
  route_table_id = aws_route_table.jenkins_public_route_table.id
}