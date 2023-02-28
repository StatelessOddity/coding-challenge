resource "aws_vpc" "rdx" {
  cidr_block           = var.rdx_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "RDX VPC"
  }
}

resource "aws_internet_gateway" "rdx" {
  vpc_id = aws_vpc.rdx.id
  tags = {
    Name = "RXD Internet Gateway"
  }
}

resource "aws_subnet" "rdx_stack" {
  count             = var.subnet_count.rdx_stack
  vpc_id            = aws_vpc.rdx.id
  cidr_block        = var.rdx_stack_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "RDX stack subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "database" {
  count             = var.subnet_count.database
  vpc_id            = aws_vpc.rdx.id
  cidr_block        = var.database_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "Database subnet ${count.index + 1}"
  }
}

resource "aws_route_table" "rdx_stack" {
  vpc_id = aws_vpc.rdx.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rdx.id
  }
  tags = {
    Name = "RDX public route table"
  }
}

resource "aws_route_table_association" "rdx_stack" {
  count          = var.subnet_count.rdx_stack
  route_table_id = aws_route_table.rdx_stack.id
  subnet_id      = aws_subnet.rdx_stack[count.index].id
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.rdx.id
  tags = {
    Name = "RDX private route table"
  }
}

resource "aws_route_table_association" "database" {
  count          = var.subnet_count.database
  route_table_id = aws_route_table.database.id
  subnet_id      = aws_subnet.database[count.index].id
}

resource "aws_db_subnet_group" "database" {
  name        = "database"
  description = "Subnet group for the PostreSQL database"
  subnet_ids  = [for subnet in aws_subnet.database : subnet.id]
}

resource "aws_eip" "fullnode" {
  count    = var.full_node.count
  instance = aws_instance.full_node[count.index].id
  vpc      = true
  tags = {
    "Name" = "Full Node IP ${count.index + 1}"
  }
}

resource "aws_eip" "bastion" {
  count    = var.bastion.count
  instance = aws_instance.bastion[count.index].id
  vpc      = true
  tags = {
    "Name" = "Bastion external IP ${count.index + 1}"
  }
}