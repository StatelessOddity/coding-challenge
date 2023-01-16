resource "aws_instance" "full_node_ec2" {
  count = var.full_node_ec2.count
  ami = data.aws_ami.ubuntu.id
  instance_type = var.full_node_ec2.instance_type
  subnet_id = aws_subnet.rdx_public_subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.rdx_public_security_group.id]
  
  tags = {
Name = "Full Node ${count.index + 1}"
  }
}