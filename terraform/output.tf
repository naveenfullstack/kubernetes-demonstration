output "Jenkins_elastic_ip" {
  value       = aws_eip.othm_jenkings_ip.public_ip
  description = "Elastic IP of the EC2 instance"
}

output "jenkins_instance_id" {
  value       = aws_instance.othm_jenkings_ec2.id
  description = "ID of the EC2 instance"
}