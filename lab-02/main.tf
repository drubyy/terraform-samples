terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

module "bastion-host" {
  source                = "TheAksel/bastion-host/aws"
  version               = "0.0.10"
  ssh_key_name          = "home"
  subnet_id             = aws_subnet.lab02-subnet-public-1a.id
  vpc_id                = aws_vpc.lab02-vpc.id
  bastion_instance_type = "t2.micro"
  bastion_name          = "Bastion"
}

resource "aws_instance" "private-app-server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.lab02-subnet-private-1a.id
  security_groups             = ["${aws_security_group.allow-all-traffic.id}"]
  associate_public_ip_address = true

  user_data = file("${path.module}/scripts/user-data.sh")

  tags = {
    Name = "App server"
  }
}

output "public_ip" {
  description = "Public instance IP"
  value       = module.bastion-host.instance_public_ip
}

output "private_ip" {
  description = "Private instance IP"
  value       = aws_instance.private-app-server.*.private_ip
}

output "load_balancer_dns_name" {
  description = "DNS name of load balancer"
  value       = aws_lb.lab02-alb.dns_name
}