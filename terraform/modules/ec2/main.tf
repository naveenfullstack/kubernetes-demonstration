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
# Elastic IP
# ---------------------------------------------------------

resource "aws_eip" "othm_jenkings_ip" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-jenkins-eip"
  }
}

# ---------------------------------------------------------
# EC2 Instance
# ---------------------------------------------------------

resource "aws_instance" "othm_jenkings_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  vpc_security_group_ids = [
    var.jenkins_sg
  ]

  # The Elastic IP will be attached separately.
  associate_public_ip_address = true

  iam_instance_profile = var.iam_role

  root_block_device { 
    volume_size = 30 
    volume_type = "gp3" 
    delete_on_termination = true 
    encrypted = true 
  }

  tags = {
    Name = "${var.name}-jenkings-${var.environment}"
  }
}

# ---------------------------------------------------------
# Elastic IP Association
# ---------------------------------------------------------

resource "aws_eip_association" "othm_jenkings_ip" {
  instance_id   = aws_instance.othm_jenkings_ec2.id
  allocation_id = aws_eip.othm_jenkings_ip.id
}