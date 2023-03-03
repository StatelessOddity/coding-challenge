resource "github_actions_secret" "ansible_inventory" {
  repository      = "coding-challenge"
  secret_name     = "ANSIBLE_INVENTORY"
  plaintext_value = data.template_file.ansible_inventory.rendered
}