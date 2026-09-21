# ---------------------------------------------------------
# Provider
# ---------------------------------------------------------

provider "aws" {
  region  = var.aws_region
  profile = "fitwin-${var.envirement}"
}

# ---------------------------------------------------------
# S3 Bucket
# ---------------------------------------------------------

resource "aws_s3_bucket" "othm_assets" {
  bucket = "${var.name}-assets-${var.envirement}-public"

  tags = {
    Name        = var.name
    Environment = var.envirement
  }
}

# ---------------------------------------------------------
# VPC | 2 Avalability Zones
# ---------------------------------------------------------

resource "aws_vpc" "othm_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = var.name
  }
}

# Public Subnets

# Availability Zone A

resource "aws_subnet" "public_1a" {
  vpc_id = aws_vpc.othm_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.name}-public-subnet-1a"
    Environment = var.envirement
  }
}

# ---------------------------------------------------------
# Internet Gateway
# ---------------------------------------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.othm_vpc.id

  tags = {
    Name        = "${var.name}-igw"
    Environment = var.envirement
  }
}

# ---------------------------------------------------------
# Public Route Table
# ---------------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.othm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.name}-public-route-table"
    Environment = var.envirement
  }
}

# "assign" the route table to the subnet

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

# ---------------------------------------------------------
# Security Group for Jenkings EC2 Instance
# ---------------------------------------------------------

resource "aws_security_group" "othm_jenkings_sg" {
  name        = "${var.name}-jenkings-sg"
  description = "Security group for jenkings ec2"
  vpc_id      = aws_vpc.othm_vpc.id

  # HTTP
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Jenkins
  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-jenkings-sg"
  }
}

# ---------------------------------------------------------
# Elastic IP
# ---------------------------------------------------------

resource "aws_eip" "othm_jenkings_ip" {
  domain = "vpc"

  tags = {
    Name = "${var.envirement}-eip"
  }
}

# ---------------------------------------------------------
# Ubuntu AMI
# ---------------------------------------------------------

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
    ]
  }

  owners = ["099720109477"]
}

# ---------------------------------------------------------
# IAM Role for AWS Systems Manager
# ---------------------------------------------------------

resource "aws_iam_role" "othm_ssm" {
  name = "${var.name}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.name}-ssm-role"
  }
}

# ---------------------------------------------------------
# SSM Policy
# ---------------------------------------------------------

resource "aws_iam_role_policy_attachment" "othm_ssm" {
  role       = aws_iam_role.othm_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ---------------------------------------------------------
# Full ECR Access
# ---------------------------------------------------------

resource "aws_iam_role_policy_attachment" "othm_ecr" {
  role       = aws_iam_role.othm_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

# ---------------------------------------------------------
# EC2 Instance Profile
# ---------------------------------------------------------

resource "aws_iam_instance_profile" "othm_ssm" {
  name = "${var.name}-ssm-profile"
  role = aws_iam_role.othm_ssm.name
}

# ---------------------------------------------------------
# EC2 Instance
# ---------------------------------------------------------

resource "aws_instance" "othm_jenkings_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.public_1a.id

  vpc_security_group_ids = [
    aws_security_group.othm_jenkings_sg.id
  ]

  # The Elastic IP will be attached separately.
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.othm_ssm.name

  root_block_device { 
    volume_size = 30 
    volume_type = "gp3" 
    delete_on_termination = true 
    encrypted = true 
  }

  tags = {
    Name = "${var.name}-jenkings"
  }
}

# ---------------------------------------------------------
# Elastic IP Association
# ---------------------------------------------------------

resource "aws_eip_association" "othm_jenkings_ip" {
  instance_id   = aws_instance.othm_jenkings_ec2.id
  allocation_id = aws_eip.othm_jenkings_ip.id
}