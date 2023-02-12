output "fullnode_ec2_public_IP" {
  value = aws_eip.fullnode_ip[count.index].public_ip
}

output "fullnode_eip_public_IP" {
  value = aws_instance.full_node_ec2[count.index].public_ip
}