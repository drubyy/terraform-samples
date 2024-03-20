resource "aws_subnet" "subnet_public_1a" {
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 3, 1)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public subnet ap-southeast-1a"
  }
}

resource "aws_subnet" "subnet_private_1a" {
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 3, 2)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "Private subnet ap-southeast-1a"
  }
}

resource "aws_subnet" "subnet_private_1b" {
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 3, 3)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "Private subnet ap-southeast-1b"
  }
}