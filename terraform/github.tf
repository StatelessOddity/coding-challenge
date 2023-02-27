resource "github_actions_secret" "fullnode_external_ip" {
  count           = var.full_node.count
  repository      = "coding-challenge"
  secret_name     = "IP"
  plaintext_value = aws_eip.fullnode_ip[count.index].public_ip
}

resource "github_actions_secret" "ansible_inventory" {
  repository      = "coding-challenge"
  secret_name     = "ANSIBLE_INVENTORY"
  plaintext_value = data.template_file.ansible_inventory.rendered
}