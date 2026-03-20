terraform {
  required_version = ">= 1.13.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.94"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = var.proxmox_api_token
  insecure  = true

  ssh {
    agent       = false
    username    = "root"
    private_key = var.ssh_private_key
  }
}

module "redis" {
  source = "../../"

  identifier     = "my-redis"
  engine         = "redis"
  engine_version = "7.2"
  instance_class = "cache.t3.medium"

  allocated_storage = 10
  port              = 6379
  maxmemory_policy  = "allkeys-lru"
  requirepass       = var.redis_password

  target_node = "pve"
  template_id = 9000

  ip_address     = "192.168.1.70/24"
  gateway        = "192.168.1.1"
  network_bridge = "vmbr0"

  ssh_user        = "ubuntu"
  ssh_public_keys = [var.ssh_public_key]

  allowed_cidrs = ["192.168.1.0/24"]

  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
