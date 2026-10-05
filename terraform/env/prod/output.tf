output "vpc_id" {
   value = module.vpc.vpc_id
}

output "jenkins_ec2_server_id" {
   value = module.ec2.instance_id
}

output "jenkins_ec2_public_ip" {
   value = module.ec2.jenkins_public_ip
}