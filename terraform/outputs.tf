output "fullnode_ec2_public_ips" {
  value = ["${aws_eip.fullnode_ip.*.public_ip}"]
}