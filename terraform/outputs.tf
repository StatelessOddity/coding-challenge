output "ansible_inventory" {
  value = data.template_file.ansible_inventory.rendered
}
