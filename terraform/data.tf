# AMI ID for the RDX stack EC2s

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

# Ansible inventory used for EC2s configuration

data "template_file" "ansible_inventory" {
  template = file("./templates/hosts.tpl")
  vars = {
    bastion          = "${join("\n", aws_eip.bastion.*.public_ip)}"
    fullnodes        = "${join("\n", aws_instance.full_node.*.private_ip)}"
    data_aggregators = "${join("\n", aws_instance.data_aggregator.*.private_ip)}"
    gateway_api      = "${join("\n", aws_instance.gateway_api.*.private_ip)}"
  }
}

data "template_file" "ssh_config" {
  template = file("./templates/ssh.tpl")
  vars = {
    stack_network_prefix = "${join("\n", aws_instance.full_node.*.private_ip)}"
    bastion              = "${join(".", slice(split(aws_eip.bastion.*.public_ip, "."), 0, 1))}"
  }
}

resource "local_file" "ansible_inventory" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "hosts"
}

resource "local_file" "ssh_config" {
  content  = data.template_file.ssh_config.rendered
  filename = "ssh.cfg"
}