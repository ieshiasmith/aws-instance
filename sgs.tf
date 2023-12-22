resource "aws_security_group" "ssh_sg" {
  name        = "aws_instance_ssh_sg"
  description = "Allow ssh traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "Server RPC Calls TCP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block, var.my_ip]
  }

  ingress {
    description = "vault"
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block, var.my_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
