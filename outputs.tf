output "cache_instance_id" {
  description = "Proxmox VM ID of the cache instance"
  value       = proxmox_virtual_environment_vm.cache_instance.vm_id
}

output "cache_instance_name" {
  description = "Name of the cache instance"
  value       = proxmox_virtual_environment_vm.cache_instance.name
}

output "endpoint" {
  description = "Connection endpoint (address:port)"
  value       = "${local.instance_address}:${var.port}"
}

output "address" {
  description = "IP address of the cache instance"
  value       = local.instance_address
}

output "port" {
  description = "Port of the cache engine"
  value       = var.port
}

output "connection_string" {
  description = "Redis connection URI"
  sensitive   = true
  value       = var.requirepass != "" ? "redis://:${var.requirepass}@${local.instance_address}:${var.port}" : "redis://${local.instance_address}:${var.port}"
}

output "ssh_connection" {
  description = "SSH connection command for the cache instance"
  value       = "ssh ${var.ssh_user}@${local.instance_address}"
}
