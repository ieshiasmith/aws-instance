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
  # public_subnet_0 = element(data.terraform_remote_state.vpc.outputs.public_subnet_ids, 0)
  # public_subnets  = data.terraform_remote_state.vpc.outputs.*.public_subnet_ids
  # vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnet_0 = "subnet-05d98c13d2b22d16b"
  public_subnets  = ["subnet-05d98c13d2b22d16b", "subnet-0a63f11b5872f7be6"]
  vpc_id          = "vpc-0e984b200b6f7844f"
  // This AMI is the Ubuntu 20.04 located in us-east-2
  my_ip      = var.my_ip
  cidr_block = var.cidr_block
  #  ami_id             = data.aws_ami.ubuntu_focal.image_id
  ami_id             = "ami-01251fbaa37843d10"
  management_key     = "management"
  management_privkey = base64decode(var.management_privkey)
  ssh_sg             = aws_security_group.ssh_sg.id
}

resource "aws_instance" "generic_instance" {
  count                       = 1
  ami                         = local.ami_id
  instance_type               = "m5.xlarge"
  key_name                    = local.management_key
  monitoring                  = true
  vpc_security_group_ids      = [local.ssh_sg]
  subnet_id                   = local.public_subnet_0
  iam_instance_profile        = aws_iam_instance_profile.generic_instance.name
  associate_public_ip_address = true
  tags = {
    Name = "aws-instance-${count.index}",
  }
  root_block_device {
    volume_size = 100
  }

  user_data = <<EOF
#!/bin/bash
exec > /tmp/setup.log 2>&1

### Install Docker #############################################################
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce -y
EOF

}
