resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }
}

resource "aws_route_table_association" "subnet_association_igw" {
  subnet_id      = aws_subnet.subnet_public_1a.id
  route_table_id = aws_route_table.route_table.id
}

# For NAT
resource "aws_eip" "nat_gw_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.subnet_public_1a.id
}

resource "aws_route_table" "route_table_for_nat" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}
resource "aws_route_table_association" "subnet_association_nat_1" {
  subnet_id      = aws_subnet.subnet_private_1a.id
  route_table_id = aws_route_table.route_table_for_nat.id
}

resource "aws_route_table_association" "subnet_association_nat_2" {
  subnet_id      = aws_subnet.subnet_private_1b.id
  route_table_id = aws_route_table.route_table_for_nat.id
}