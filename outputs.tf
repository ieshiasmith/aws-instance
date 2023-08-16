output "ami_id" {
  description = "AMI Used to build EC2 Instance"
  value       = local.ami_id
}

output "public_ips" {
  value = aws_instance.hashistack.*.public_ip
}