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
# EC2 Instance
# ---------------------------------------------------------

resource "aws_instance" "jenkins_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.jenkins_public_subnet_1_a.id

  vpc_security_group_ids = [
    aws_security_group.jenkings_sg.id
  ]

  # The Elastic IP will be attached separately.
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.jenkins_iam_ssm.name

  root_block_device { 
    volume_size = 30 
    volume_type = "gp3" 
    delete_on_termination = true 
    encrypted = true 
  }

  tags = {
    Name = "${var.name}-ec2-${var.environment}"
  }
}

# ---------------------------------------------------------
# Elastic IP Association
# ---------------------------------------------------------

resource "aws_eip_association" "jenkins_eip" {
  instance_id   = aws_instance.jenkins_ec2.id
  allocation_id = aws_eip.jenkins_eip.id
}