output "jenkins_ec2_server_id" {
   value = aws_instance.jenkins_ec2.id
}

output "jenkins_ec2_public_ip" {
   value = aws_eip.jenkins_eip.public_ip
}

output "instance_sg" {
   value = aws_security_group.jenkings_sg.id
}