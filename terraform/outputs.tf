output "fullnode_ec2_public_ips" {
  value = ["${aws_eip.fullnode_ip.*.public_ip}"]
}

output "data_aggregator_ec2_public_ips" {
  value = ["${aws_eip.data_aggregator_ip.*.public_ip}"]
}

output "gateway_api_ec2_public_ips" {
  value = ["${aws_eip.gateway_api_ip.*.public_ip}"]
}