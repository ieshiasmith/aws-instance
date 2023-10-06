output "ami_id" {
  description = "AMI Used to build EC2 Instance"
  value       = local.ami_id
}

output "public_ips" {
  value = aws_instance.generic_instance.*.public_ip
}

output "private_ips" {
  value = aws_instance.generic_instance.*.private_ip
}

output "my_ip" {
  value = local.my_ip
}

output "instance_ids" {
  value = aws_instance.generic_instance.*.id
}

output "instance_type" {
  value = local.instance_type
}

output "volume_size" {
  value = local.volume_size
}