locals {
  # AWS ElastiCache cache.t3 instance class mappings
  instance_types = {
    "cache.t3.small"   = { cores = 2, memory = 2048 }
    "cache.t3.medium"  = { cores = 2, memory = 4096 }
    "cache.t3.large"   = { cores = 2, memory = 8192 }
    "cache.t3.xlarge"  = { cores = 4, memory = 16384 }
    "cache.t3.2xlarge" = { cores = 8, memory = 32768 }
    "custom"           = { cores = var.custom_cores, memory = var.custom_memory }
  }

  selected  = local.instance_types[var.instance_class]
  vm_cores  = local.selected.cores
  vm_memory = local.selected.memory

  # Redis maxmemory = 75% of total (leave room for OS)
  redis_maxmemory_mb = floor(local.vm_memory * 3 / 4)

  # IP without CIDR prefix
  instance_address = split("/", var.ip_address)[0]

  # Convert map tags to list format for Proxmox
  tag_list = [for k, v in var.tags : "${lower(k)}-${lower(v)}"]
}
