output "fullnode_ec2_public_IP" {
  value = aws_eip.fullnode_ip.public_ip
}