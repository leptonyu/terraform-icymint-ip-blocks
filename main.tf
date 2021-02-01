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
  map_blocks = {
    aws = {
      disable = var.disable_aws
      blocks  = [for n in jsondecode(data.http.aws.body).prefixes : n.ip_prefix if !can(regex("^cn-", n.region)) && !can(regex("^120",n.ip_prefix))]
    }
    google = {
      disable = var.disable_google
      blocks = [for n in jsondecode(data.http.google.body).prefixes :
      n.ipv4Prefix if can(n.ipv4Prefix) && !can(regex("^3[45]\\.", n.ipv4Prefix))]
    }
    github = {
      disable = var.disable_github
      blocks = flatten([for k, n in jsondecode(data.http.github.body) : [for ip in n : ip if !can(regex(":", ip))]
      if can(regex("^(hooks|web|api|git|pages|importer|actions|dependabot)$", k))])
    }
    cloudflare = {
      disable = var.disable_cloudflare
      blocks  = split("\n", chomp(data.http.cloudflare.body))
    }

    as = {
      disable = false
      blocks  = [for as in data.external.as : split("\n", chomp(as.result.value))]
    }

    base = {
      disable = false
      blocks  = var.base_blocks
    }

    default = {
      disable = !var.use_predefined_blocks
      blocks  = [for x in split("\n", chomp(file(format("%s/default.txt", path.module)))) : x if can(regex("^\\d", x))]
    }
  }

  blocks = flatten([for k, v in local.map_blocks : v.blocks if !v.disable])
}

data "external" "block" {
  program = [format("%s/cidr.sh", path.module)]
  query = {
    value = join("\n", local.blocks)
  }
}

locals {
  shink_blocks         = split("\n", data.external.block.result.value)
  shink_layered_blocks = { for k, n in data.external.layered_block : k => split("\n", n.result.value) }
}

data "external" "layered_block" {
  for_each = var.layered_blocks
  program  = [format("%s/cidr.sh", path.module)]
  query = {
    value = join("\n", flatten([local.shink_blocks, each.value]))
  }
}


