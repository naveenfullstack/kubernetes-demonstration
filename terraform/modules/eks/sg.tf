# =========================================================
# ALLOW JENKINS EC2 TO ACCESS THE PRIVATE EKS API
# =========================================================

resource "aws_vpc_security_group_ingress_rule" "jenkins_to_eks_api" {
  security_group_id = var.eks_security_group_id

  referenced_security_group_id = var.jenkins_security_group_id

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443

  description = "Allow Jenkins EC2 to access the private EKS API"
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_to_eks_api_http" {
  security_group_id = var.eks_security_group_id

  referenced_security_group_id = var.alb_security_group_id

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80

  description = "Allow Jenkins HTTP EC2 to access the private EKS API"
}