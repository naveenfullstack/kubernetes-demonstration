# Configure kubectl

aws eks update-kubeconfig \
  --region us-east-1 \
  --name othm-eks-prod \
  --profile fitwin-dev

  # Import the existing EKS access entry

  terraform import \
  'module.eks.aws_eks_access_entry.admin' \
  'othm-eks-prod:arn:aws:iam::125022369875:user/terraform'

  # Import the existing access policy association

  terraform import \
  'module.eks.aws_eks_access_policy_association.admin' \
  'othm-eks-prod#arn:aws:iam::125022369875:user/terraform#arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy'

  ## Create iam user in aws for eks access console