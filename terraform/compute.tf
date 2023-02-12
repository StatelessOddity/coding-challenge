resource "aws_instance" "full_node_ec2" {
  count                  = var.full_node_ec2.count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.full_node_ec2.instance_type
  subnet_id              = aws_subnet.rdx_public_subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.rdx_public_security_group.id]
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

resource "aws_instance" "data_aggregator_ec2" {
  count                  = var.data_aggregator_ec2.count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.data_aggregator_ec2.instance_type
  subnet_id              = aws_subnet.rdx_public_subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.rdx_public_security_group.id]
  key_name               = aws_key_pair.rdx_key.key_name
  tags = {
    Name = "Data Aggregator ${count.index + 1}"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = var.rdx_private_key
    timeout     = "4m"
  }
}

resource "aws_instance" "gateway_api_ec2" {
  count                  = var.gateway_api_ec2.count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.gateway_api_ec2.instance_type
  subnet_id              = aws_subnet.rdx_public_subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.rdx_public_security_group.id]
  key_name               = aws_key_pair.rdx_key.key_name
  tags = {
    Name = "Gateway API ${count.index + 1}"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = var.rdx_private_key
    timeout     = "4m"
  }
}