output "fullnode_ec2_public_ips" {
  value = ["${aws_eip.fullnode.*.public_ip}"]
}

output "data_aggregator_public_ips" {
  value = ["${aws_eip.data_aggregator_ip.*.public_ip}"]
}

output "gateway_api_public_ips" {
  value = ["${aws_eip.gateway_api_ip.*.public_ip}"]
}

# Inventory:

output "ansible_inventory" {
  value = data.template_file.ansible_inventory.rendered
}