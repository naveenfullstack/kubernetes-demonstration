output "instance_id" {
    value = aws_instance.othm_jenkings_ec2.id
}

output "jenkins_public_ip" {
    value = aws_eip.othm_jenkings_ip.domain
}