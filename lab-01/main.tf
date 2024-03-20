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

data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_vpc" "lab01-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "lab01-subnet" {
  cidr_block        = cidrsubnet(aws_vpc.lab01-vpc.cidr_block, 3, 1)
  vpc_id            = aws_vpc.lab01-vpc.id
  availability_zone = "ap-southeast-1a"
}

resource "aws_security_group" "ingress-ssh-test" {
  name   = "allow-ssh-sg"
  vpc_id = aws_vpc.lab01-vpc.id

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]

    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress_http-test" {
  name   = "allow-http-sg"
  vpc_id = aws_vpc.lab01-vpc.id

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]

    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "lab01-vpc-igw" {
  vpc_id = aws_vpc.lab01-vpc.id
}

resource "aws_route_table" "route-table-lab01-vpc" {
  vpc_id = aws_vpc.lab01-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab01-vpc-igw.id
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.lab01-subnet.id
  route_table_id = aws_route_table.route-table-lab01-vpc.id
}

resource "aws_spot_instance_request" "app_server" {
  ami                         = data.aws_ami.amzn-linux-2023-ami.id
  instance_type               = "t2.micro"
  key_name                    = "home"
  subnet_id                   = aws_subnet.lab01-subnet.id
  security_groups             = ["${aws_security_group.ingress-ssh-test.id}", "${aws_security_group.ingress_http-test.id}"]
  associate_public_ip_address = true

  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name = "ExampleAppServerInstance"
  }
}