resource "github_actions_secret" "example_secret" {
  count = aws_instance.full_node_ec2[count.index]
  repository       = "coding-challenge"
  secret_name      = "IP"
  plaintext_value  = aws_instance.full_node_ec2[count.index].public_ip
}