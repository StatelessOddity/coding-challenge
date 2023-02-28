# Instances that run Full Nodes with Core API

resource "aws_instance" "full_node" {
  count                  = var.full_node.count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.full_node.instance_type
  subnet_id              = aws_subnet.rdx_stack[count.index].id
  vpc_security_group_ids = [aws_security_group.rdx_stack.id]
  key_name               = aws_key_pair.rdx_key.key_name
  tags = {
    Name = "Full Node ${count.index + 1}"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = var.rdx_private_key
    timeout     = "4m"
  }
}

resource "aws_instance" "data_aggregator" {
  count                  = var.data_aggregator.count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.data_aggregator.instance_type
  subnet_id              = aws_subnet.rdx_stack[count.index].id
  vpc_security_group_ids = [aws_security_group.rdx_stack.id]
  key_name               = aws_key_pair.rdx_key.key_name
  tags = {
    Name = "Data Aggregator ${count.index + 1}"
  }
}

resource "aws_instance" "gateway_api" {
  count                  = var.gateway_api.count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.gateway_api.instance_type
  subnet_id              = aws_subnet.rdx_stack[count.index].id
  vpc_security_group_ids = [aws_security_group.rdx_stack.id]
  key_name               = aws_key_pair.rdx_key.key_name
  tags = {
    Name = "Gateway API ${count.index + 1}"
  }
}

resource "aws_instance" "monitoring" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.monitoring.instance_type
  subnet_id              = aws_subnet.rdx_stack[count.index].id
  vpc_security_group_ids = [aws_security_group.rdx_stack.id]
  key_name               = aws_key_pair.rdx_key.key_name
  tags = {
    Name = "Monitoring"
  }
}

resource "aws_instance" "bastion" {
  count                  = var.bastion.count
  ami                    = "ami-005b11f8b84489615"
  instance_type          = var.bastion.instance_type
  subnet_id              = aws_subnet.rdx_stack[count.index].id
  vpc_security_group_ids = [aws_security_group.rdx_stack.id]
  key_name               = aws_key_pair.rdx_key.key_name
  tags = {
    Name = "Bastion Desktop"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-linux"
    private_key = var.rdx_private_key
    timeout     = "4m"
  }
}