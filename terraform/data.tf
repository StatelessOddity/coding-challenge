data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "template_file" "ansible_inventory" {
  template = file("./templates/hosts.tpl")
  vars = {
    fullnode_ips        = "${join("\n", aws_eip.fullnode_ip.*.public_ip)}"
    data_aggregator_ips = "${join("\n", aws_eip.data_aggregator_ip.*.public_ip)}"
    gateway_api_ips     = "${join("\n", aws_eip.gateway_api_ip.*.public_ip)}"
  }
}

resource "local_file" "ansible_inventory" {
  content  = "${data.template_file.ansible_inventory.rendered}"
  filename = "inventory"
}