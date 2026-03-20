output "cache_instance_id" {
  description = "Proxmox VM ID of the cache instance"
  value       = module.redis.cache_instance_id
}

output "cache_instance_name" {
  description = "Name of the cache instance"
  value       = module.redis.cache_instance_name
}

output "endpoint" {
  description = "Connection endpoint (address:port)"
  value       = module.redis.endpoint
}

output "address" {
  description = "IP address of the cache instance"
  value       = module.redis.address
}

output "port" {
  description = "Port of the cache engine"
  value       = module.redis.port
}

output "connection_string" {
  description = "Redis connection URI"
  sensitive   = true
  value       = module.redis.connection_string
}

output "ssh_connection" {
  description = "SSH connection command"
  value       = module.redis.ssh_connection
}
