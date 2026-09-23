# ---------------------------------------------------------
# IAM Role for Resources
# ---------------------------------------------------------

resource "aws_iam_role" "othm_iam" {
  name = "${var.name}-iam-role-${var.environment}"

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
    Name = "${var.name}-resources-role"
  }
}

# ---------------------------------------------------------
# SSM Access for IAM
# ---------------------------------------------------------

resource "aws_iam_role_policy_attachment" "othm_ssm" {
  role       = aws_iam_role.othm_iam.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ---------------------------------------------------------
# Full ECR Access for IAM
# ---------------------------------------------------------

resource "aws_iam_role_policy_attachment" "othm_ecr" {
  role       = aws_iam_role.othm_iam.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

# ---------------------------------------------------------
# EC2 Instance Access for IAM
# ---------------------------------------------------------

resource "aws_iam_instance_profile" "othm_iam_ssm" {
  name = "${var.name}-ssm-profile-${var.environment}"
  role = aws_iam_role.othm_iam.name
}