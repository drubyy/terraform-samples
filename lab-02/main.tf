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

module "bastion-host" {
  source                = "TheAksel/bastion-host/aws"
  version               = "0.0.10"
  ssh_key_name          = "home"
  subnet_id             = aws_subnet.subnet_public_1a.id
  vpc_id                = aws_vpc.vpc.id
  bastion_instance_type = "t2.micro"
  bastion_name          = "Bastion"
}

output "bastion_public_ip" {
  description = "Bastion public IP"
  value       = module.bastion-host.instance_public_ip
}

output "load_balancer_dns_name" {
  description = "DNS name of load balancer"
  value       = aws_lb.alb.dns_name
}