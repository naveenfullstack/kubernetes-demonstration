output "vpc_id" {
  value = aws_vpc.othm_vpc.id
}

output "public_subnet_1_a_id" {
  value = aws_subnet.public_subnet_1_a.id
}