locals {
  hcp_bucket_name = "demoland"
  environment     = "development"
  region          = "us-east-2"
}

data "aws_ami" "ubuntu_focal" {
  owners      = ["self"]
  most_recent = true
  filter {
    name   = "name"
    values = ["packer_AWS_UBUNTU_20.04_*"]
  }
}

locals {
  public_subnet_0 = element(data.terraform_remote_state.vpc.outputs.public_subnet_ids, 0)
  public_subnets  = data.terraform_remote_state.vpc.outputs.*.public_subnet_ids
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  // This AMI is the Ubuntu 20.04 located in us-east-2
  my_ip              = var.my_ip
  cidr_block         = var.cidr_block
  ami_id             = data.aws_ami.ubuntu_focal.image_id
  management_key     = "management"
  management_privkey = base64decode(var.management_privkey)
  ssh_sg             = aws_security_group.ssh_sg.id
}

resource "aws_instance" "generic_instance" {
  count                       = 1
  ami                         = local.ami_id
  instance_type               = "t3.medium"
  key_name                    = local.management_key
  monitoring                  = true
  vpc_security_group_ids      = [local.ssh_sg]
  subnet_id                   = local.public_subnet_0
  iam_instance_profile        = aws_iam_instance_profile.generic_instance.name
  associate_public_ip_address = true
  tags = {
    Name = "aws-instance-${count.index}",
  }
  user_data = <<EOF
#!/bin/bash
exec > /tmp/setup.log 2>&1

### Install Docker #############################################################
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker
EOF

}
