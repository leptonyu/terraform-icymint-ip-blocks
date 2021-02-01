output "blocks" {
  value = local.shink_layered_blocks
}

 resource "local_file" "ip_blocks" {
   content              = join("\n", local.shink_layered_blocks.default)
   file_permission      = "0644"
   directory_permission = "0755"
   filename             = format("%s/as/all.txt", path.module)
 }
