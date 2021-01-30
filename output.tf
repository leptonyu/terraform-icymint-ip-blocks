output "blocks" {
  # value = local.shink_blocks
  value = var.shink_blocks ? local.shink_blocks : local.blocks
}
