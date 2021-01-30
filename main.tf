data "http" "aws" {
  url = "https://ip-ranges.amazonaws.com/ip-ranges.json"
}

data "http" "google" {
  url = "https://www.gstatic.com/ipranges/goog.json"
}

data "http" "github" {
  url = "https://api.github.com/meta"
}

data "http" "cloudflare" {
  url = "https://www.cloudflare.com/ips-v4"
}

data "external" "as" {
  for_each = toset(var.as)
  program  = [format("%s/get_as.sh", path.module)]
  query = {
    name = each.value
    path = var.as_path
  }
}

locals {
  aws_blocks = [for n in jsondecode(data.http.aws.body).prefixes : n.ip_prefix if !can(regex("^cn-", n.region))]
  goo_blocks = [for n in jsondecode(data.http.google.body).prefixes :
  n.ipv4Prefix if can(n.ipv4Prefix) && !can(regex("^3[45]\\.", n.ipv4Prefix))]
  github_blocks = flatten([for k, n in jsondecode(data.http.github.body) : [for ip in n : ip if !can(regex(":", ip))]
  if can(regex("^(hooks|web|api|git|pages|importer|actions|dependabot)$", k))])
  cloudflare_blocks = split("\n", chomp(data.http.cloudflare.body))
  as_blocks         = [for as in data.external.as : split("\n", chomp(as.result.value))]


  blocks = flatten([var.blocks, local.aws_blocks, local.goo_blocks, local.github_blocks, local.cloudflare_blocks, local.as_blocks])
}

data "external" "block" {
  program = [format("%s/cidr.sh", path.module)]
  query = {
    value = join("\n", local.blocks)
  }
}

locals {
  shink_blocks = split("\n", data.external.block.result.value)
}

