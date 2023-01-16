resource "github_actions_secret" "example_secret" {
  count = var.full_node_ec2.count
  repository       = "coding-challenge"
  secret_name      = "IP"
  plaintext_value  = aws_eip.fullnode_ips[count.index].public_ip
}