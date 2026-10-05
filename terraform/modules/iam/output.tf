output iam_role_name {
  value       = aws_iam_role.othm_iam.name
}

output "iam_ssm_profile_name" {
  value = aws_iam_instance_profile.othm_iam_ssm.name
}