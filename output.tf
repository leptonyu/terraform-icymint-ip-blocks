output "blocks" {
  value = local.shink_layered_blocks
}

resource "local_file" "ip_blocks" {
  for_each             = local.shink_layered_blocks
  content              = join("\n", each.value)
  file_permission      = "0644"
  directory_permission = "0755"
  filename             = format("%s/%s.txt", var.as_path, each.key)
}
