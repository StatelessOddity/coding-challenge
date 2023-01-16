/* 
This setup is pretty straightforward, I'm not creating any custom modules.
My goal was to prepare something similar to how production setup MIGHT look like for the client.
Of course I skipped redundancy and scaled it down/simplified to save costs :)
*/

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "rdx_vpc" {
  cidr_block = var.rdx_vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    "Name" = "RDX VPC"
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
  route = [{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rdx_internet_gateway.id
    carrier_gateway_id         = ""
    core_network_arn           = ""
    destination_prefix_list_id = ""
    egress_only_gateway_id     = ""
    instance_id                = ""
    ipv6_cidr_block            = ""
    local_gateway_id           = ""
    nat_gateway_id             = ""
    network_interface_id       = ""
    transit_gateway_id         = ""
    vpc_endpoint_id            = ""
    vpc_peering_connection_id  = ""
  }]
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

resource "aws_security_group" "rdx_public_security_group" {
  name = "rdx_public_security_group"
  description = "Security for compute EC2 instances of Full Node, Gateway and monitoring"
  vpc_id = aws_vpc.rdx_vpc.id
}

resource "aws_security_group_rule" "rdx_public_security_group_rules" {
  count = length(var.public_security_group_rules)
  type              = "ingress"
  from_port         = var.public_security_group_rules[count.index].from_port
  to_port           = var.public_security_group_rules[count.index].to_port
  protocol          = var.public_security_group_rules[count.index].protocol
  cidr_blocks       = [var.public_security_group_rules[count.index].cidr_block]
  description       = var.public_security_group_rules[count.index].description
  security_group_id = aws_security_group.rdx_public_security_group.id
}

resource "aws_security_group" "rdx_private_security_group" {
  name = "rdx_private_security_group"
  description = "security group for the Gateway API PostgreSQL Database"
  vpc_id = aws_vpc.rdx_vpc

  ingress = [ {
    description = "Allow PostgreSQL traffic fom Node and Gateway"
    from_port = 5432
    protocol = "tcp"
    security_groups = [aws_security_group.rdx_public_security_group]
    to_port = 5432
    cidr_blocks = []
    ipv6_cidr_blocks= []
    prefix_list_ids = []
    self = false
  } ]
}

resource "aws_db_subnet_group" "rdx_private_subnet_group" {
  name = "rdx_private_subnet_group"
  description = "Subnet group for the PostreSQL database"
  subnet_ids = [for subnet in aws_subnet.rdx_private_subnet : subnet.id]
}

data "aws_ami" "ubuntu" {
  most_recent = "true"

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hmv"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "full_node_ec2" {
  count = var.full_node_ec2.count
  ami = data.aws_ami.ubuntu.id
  instance_type = var.full_node_ec2.instance_type
  subnet_id = aws_subnet.rdx_public_subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.rdx_public_security_group.id]
  
  tags = {
    Name = "RDX Full Node ${count.index}"
  }
}