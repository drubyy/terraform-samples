resource "aws_subnet" "lab02-subnet-public-1a" {
  cidr_block              = cidrsubnet(aws_vpc.lab02-vpc.cidr_block, 3, 1)
  vpc_id                  = aws_vpc.lab02-vpc.id
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "lab02-subnet-private-1a" {
  cidr_block        = cidrsubnet(aws_vpc.lab02-vpc.cidr_block, 3, 2)
  vpc_id            = aws_vpc.lab02-vpc.id
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "Private subnet ap-southeast-1a"
  }
}

resource "aws_subnet" "lab02-subnet-private-1b" {
  cidr_block        = cidrsubnet(aws_vpc.lab02-vpc.cidr_block, 3, 3)
  vpc_id            = aws_vpc.lab02-vpc.id
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "Private subnet ap-southeast-1b"
  }
}