resource "github_actions_secret" "example_secret" {
  repository       = "coding-challenge"
  secret_name      = "IP"
  plaintext_value  = aws_instance.full_node_ec2.public_ip
}