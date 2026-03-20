################################################################################
# Cloud-Init Snippet
################################################################################

resource "proxmox_virtual_environment_file" "cloud_init" {
  content_type = "snippets"
  datastore_id = var.snippets_storage
  node_name    = var.target_node

  source_raw {
    data = templatefile("${path.module}/templates/redis-cloud-init.yaml.tftpl", {
      engine              = var.engine
      engine_version      = var.engine_version
      port                = var.port
      maxmemory_mb        = local.redis_maxmemory_mb
      maxmemory_policy    = var.maxmemory_policy
      requirepass         = var.requirepass
      persistence_enabled = var.persistence_enabled
      allowed_cidrs       = var.allowed_cidrs
      ssh_user            = var.ssh_user
    })
    file_name = "${var.identifier}-cloud-init.yaml"
  }
}

################################################################################
# Cache Instance VM
################################################################################

resource "proxmox_virtual_environment_vm" "cache_instance" {
  name      = var.identifier
  node_name = var.target_node
  vm_id     = var.vm_id

  clone {
    vm_id = var.template_id
    full  = true
  }

  cpu {
    cores = local.vm_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = local.vm_memory
  }

  disk {
    datastore_id = var.storage_pool
    interface    = "scsi0"
    size         = var.allocated_storage
  }

  network_device {
    bridge = var.network_bridge
  }

  operating_system {
    type = "l26"
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }

    user_account {
      username = var.ssh_user
      keys     = var.ssh_public_keys
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_init.id
  }

  agent {
    enabled = true
  }

  tags = local.tag_list

  lifecycle {
    ignore_changes = [
      initialization,
    ]
  }
}
