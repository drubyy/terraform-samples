resource "aws_vpc" "lab02-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "lab02-vpc-igw" {
  vpc_id = aws_vpc.lab02-vpc.id
}

resource "aws_route_table" "route-table-lab02-vpc" {
  vpc_id = aws_vpc.lab02-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab02-vpc-igw.id
  }
}

resource "aws_route_table_association" "subnet-association-igw" {
  subnet_id      = aws_subnet.lab02-subnet-public-1a.id
  route_table_id = aws_route_table.route-table-lab02-vpc.id
}

# For NAT
resource "aws_eip" "lab02-nat-gw-eip" {
  vpc = true
}

resource "aws_nat_gateway" "lab02-nat-gw" {
  allocation_id = aws_eip.lab02-nat-gw-eip.id
  subnet_id     = aws_subnet.lab02-subnet-public-1a.id
}

resource "aws_route_table" "lab02-route-table-for-nat" {
  vpc_id = aws_vpc.lab02-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.lab02-nat-gw.id
  }
}
resource "aws_route_table_association" "subnet-association-nat-1" {
  subnet_id      = aws_subnet.lab02-subnet-private-1a.id
  route_table_id = aws_route_table.lab02-route-table-for-nat.id
}

resource "aws_route_table_association" "subnet-association-nat-2" {
  subnet_id      = aws_subnet.lab02-subnet-private-1b.id
  route_table_id = aws_route_table.lab02-route-table-for-nat.id
}