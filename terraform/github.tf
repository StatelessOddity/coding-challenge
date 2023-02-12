resource "github_actions_secret" "fullnode_external_ip" {
  count           = var.full_node_ec2.count
  repository      = "coding-challenge"
  secret_name     = "IP"
  plaintext_value = aws_eip.fullnode_ip[count.index].public_ip
}