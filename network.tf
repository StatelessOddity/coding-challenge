resource "aws_vpc" "rdx_vpc" {
  cidr_block = var.rdx_vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "RDX VPC"
  }
}

resource "aws_internet_gateway" "rdx_internet_gateway" {
  vpc_id = aws_vpc.rdx_vpc.id
  tags = {
    Name = "RXD Internet Gateway"
  }
}

resource "aws_subnet" "rdx_public_subnet" {
  count = var.rdx_vpc_subnet_count.public
  vpc_id = aws_vpc.rdx_vpc.id
  cidr_block = var.rdx_public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "RDX public subnet $(count.index)"
  }
}

resource "aws_subnet" "rdx_private_subnet" {
  count = var.rdx_vpc_subnet_count.private
  vpc_id = aws_vpc.rdx_vpc.id
  cidr_block = var.rdx_private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "RDX private sunet $(count.index)"
  }
}

resource "aws_route_table" "rdx_public_route_table" {
  vpc_id = aws_vpc.rdx_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rdx_internet_gateway.id
  }
}

resource "aws_route_table_association" "public" {
  count = var.rdx_vpc_subnet_count.public
  route_table_id = aws_route_table.rdx_public_route_table.id
  subnet_id = aws_subnet.rdx_public_subnet[count.index].id
}

resource "aws_route_table" "rdx_private_route_table" {
  vpc_id = aws_vpc.rdx_vpc.id
}

resource "aws_route_table_association" "private" {
  count = var.rdx_vpc_subnet_count.private
  route_table_id = aws_route_table.rdx_private_route_table.id
  subnet_id = aws_subnet.rdx_private_subnet[count.index].id
}

resource "aws_db_subnet_group" "rdx_private_subnet_group" {
  name = "rdx_private_subnet_group"
  description = "Subnet group for the PostreSQL database"
  subnet_ids = [for subnet in aws_subnet.rdx_private_subnet : subnet.id]
}