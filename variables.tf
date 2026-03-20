################################################################################
# Instance Identity
################################################################################

variable "identifier" {
  description = "Name of the cache instance (used as VM name)"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,62}$", var.identifier))
    error_message = "Identifier must start with a letter, contain only lowercase alphanumeric characters and hyphens, and be at most 63 characters."
  }
}

variable "vm_id" {
  description = "Proxmox VM ID. If null, Proxmox will auto-assign."
  type        = number
  default     = null
}

################################################################################
# Engine
################################################################################

variable "engine" {
  description = "Cache engine to use"
  type        = string
  default     = "redis"

  validation {
    condition     = contains(["redis", "valkey"], var.engine)
    error_message = "Engine must be one of: redis, valkey."
  }
}

variable "engine_version" {
  description = "Version of the cache engine"
  type        = string
  default     = "7.2"

  validation {
    condition     = contains(["6.2", "7.0", "7.2", "7.4", "8.0"], var.engine_version)
    error_message = "Engine version must be one of: 6.2, 7.0, 7.2, 7.4, 8.0."
  }
}

################################################################################
# Instance Class
################################################################################

variable "instance_class" {
  description = "ElastiCache-style instance class"
  type        = string
  default     = "cache.t3.small"

  validation {
    condition = contains([
      "cache.t3.small",
      "cache.t3.medium",
      "cache.t3.large",
      "cache.t3.xlarge",
      "cache.t3.2xlarge",
      "custom",
    ], var.instance_class)
    error_message = "Instance class must be one of: cache.t3.small, cache.t3.medium, cache.t3.large, cache.t3.xlarge, cache.t3.2xlarge, custom."
  }
}

variable "custom_cores" {
  description = "Number of CPU cores when instance_class is 'custom'"
  type        = number
  default     = null
}

variable "custom_memory" {
  description = "Amount of memory in MB when instance_class is 'custom'"
  type        = number
  default     = null
}

variable "cpu_type" {
  description = "CPU type for the VM"
  type        = string
  default     = "x86-64-v2-AES"
}

################################################################################
# Storage
################################################################################

variable "allocated_storage" {
  description = "Storage size in GB for the cache instance"
  type        = number
  default     = 10

  validation {
    condition     = var.allocated_storage >= 5 && var.allocated_storage <= 1000
    error_message = "Allocated storage must be between 5 and 1000 GB."
  }
}

variable "storage_pool" {
  description = "Proxmox storage pool for VM disks"
  type        = string
  default     = "local-lvm"
}

variable "snippets_storage" {
  description = "Proxmox storage pool for cloud-init snippets"
  type        = string
  default     = "local"
}

################################################################################
# Redis Configuration
################################################################################

variable "port" {
  description = "Port number for the cache engine"
  type        = number
  default     = 6379

  validation {
    condition     = var.port >= 1024 && var.port <= 65535
    error_message = "Port must be between 1024 and 65535."
  }
}

variable "maxmemory_policy" {
  description = "Redis maxmemory eviction policy"
  type        = string
  default     = "allkeys-lru"

  validation {
    condition = contains([
      "noeviction",
      "allkeys-lru",
      "allkeys-lfu",
      "allkeys-random",
      "volatile-lru",
      "volatile-lfu",
      "volatile-random",
      "volatile-ttl",
    ], var.maxmemory_policy)
    error_message = "Maxmemory policy must be one of: noeviction, allkeys-lru, allkeys-lfu, allkeys-random, volatile-lru, volatile-lfu, volatile-random, volatile-ttl."
  }
}

variable "requirepass" {
  description = "Password for Redis AUTH. Leave empty to disable authentication."
  type        = string
  default     = ""
  sensitive   = true
}

variable "persistence_enabled" {
  description = "Enable RDB snapshots and AOF persistence"
  type        = bool
  default     = true
}

variable "allowed_cidrs" {
  description = "List of CIDR blocks allowed to connect to the cache port"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

################################################################################
# Proxmox Target
################################################################################

variable "target_node" {
  description = "Proxmox node to deploy the VM on"
  type        = string
}

variable "template_id" {
  description = "VM ID of the template to clone"
  type        = number
}

################################################################################
# Network
################################################################################

variable "ip_address" {
  description = "Static IP address in CIDR notation (e.g. 192.168.1.70/24)"
  type        = string

  validation {
    condition     = can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$", var.ip_address))
    error_message = "IP address must be in CIDR notation (e.g. 192.168.1.70/24)."
  }
}

variable "gateway" {
  description = "Default gateway IPv4 address"
  type        = string

  validation {
    condition     = can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$", var.gateway))
    error_message = "Gateway must be a valid IPv4 address."
  }
}

variable "network_bridge" {
  description = "Proxmox network bridge"
  type        = string
  default     = "vmbr0"
}

################################################################################
# SSH / Cloud-Init
################################################################################

variable "ssh_user" {
  description = "Default SSH user created by cloud-init"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_keys" {
  description = "List of SSH public keys to authorize"
  type        = list(string)
}

################################################################################
# Tags
################################################################################

variable "tags" {
  description = "Map of tags to apply to the instance"
  type        = map(string)
  default     = {}
}
