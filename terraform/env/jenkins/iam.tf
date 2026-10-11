# ---------------------------------------------------------
# IAM Role for Resources
# ---------------------------------------------------------

resource "aws_iam_role" "jenkins_iam" {
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

resource "aws_iam_role_policy_attachment" "jenkins_ssm" {
  role       = aws_iam_role.jenkins_iam.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ---------------------------------------------------------
# Full ECR Access for IAM
# ---------------------------------------------------------

resource "aws_iam_role_policy_attachment" "jenkins_ecr" {
  role       = aws_iam_role.jenkins_iam.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

# ---------------------------------------------------------
# EC2 Instance Access for IAM
# ---------------------------------------------------------

resource "aws_iam_instance_profile" "jenkins_iam_ssm" {
  name = "${var.name}-ssm-profile-${var.environment}"
  role = aws_iam_role.jenkins_iam.name
}

# ---------------------------------------------------------
# EKS Access for Jenkins
# ---------------------------------------------------------

resource "aws_iam_role_policy" "jenkins_eks" {
  name = "${var.name}-jenkins-eks-policy-${var.environment}"
  role = aws_iam_role.jenkins_iam.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "DescribeEKSCluster"
        Effect = "Allow"

        Action = [
          "eks:DescribeCluster"
        ]

        Resource = "arn:aws:eks:us-east-1:125022369875:cluster/othm-eks-prod"
      }
    ]
  })
}

# ---------------------------------------------------------
# EKS Access Entry for Jenkins
# ---------------------------------------------------------

resource "aws_eks_access_entry" "jenkins" {
  cluster_name  = "${var.name}-eks-prod"
  principal_arn = aws_iam_role.jenkins_iam.arn
  type          = "STANDARD"

  tags = {
    Name        = "${var.name}-jenkins-eks-access-${var.environment}"
    Environment = var.environment
  }
}

# ---------------------------------------------------------
# EKS Cluster Access Policy for Jenkins
# ---------------------------------------------------------

resource "aws_eks_access_policy_association" "jenkins_cluster_admin" {
  cluster_name  = "${var.name}-eks-prod"
  principal_arn = aws_iam_role.jenkins_iam.arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [
    aws_eks_access_entry.jenkins
  ]
}

# ---------------------------------------------------------
# EC2 Network Troubleshooting Permissions for Jenkins
# ---------------------------------------------------------

# resource "aws_iam_role_policy" "jenkins_network_read" {
#   name = "${var.name}-jenkins-network-read-${var.environment}"
#   role = aws_iam_role.jenkins_iam.id

#   policy = jsonencode({
#     Version = "2012-10-17"

#     Statement = [
#       {
#         Sid    = "ReadVpcNetworking"
#         Effect = "Allow"

#         Action = [
#           "ec2:DescribeVpcs",
#           "ec2:DescribeVpcPeeringConnections",
#           "ec2:DescribeRouteTables",
#           "ec2:DescribeSubnets",
#           "ec2:DescribeSecurityGroups",
#           "ec2:DescribeNetworkAcls",
#           "ec2:DescribeNetworkInterfaces",
#           "eks:ListClusters",
#           "eks:ListAccessEntries",
#           "eks:ListAssociatedAccessPolicies",
#           "eks:ListTagsForResource"
#         ]

#         Resource = "*"
#       }
#     ]
#   })
# }