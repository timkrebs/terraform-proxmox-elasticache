variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token"
  type        = string
  sensitive   = true
}

variable "ssh_private_key" {
  description = "SSH private key for Proxmox provider"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key to authorize on the instance"
  type        = string
}

variable "redis_password" {
  description = "Password for Redis AUTH"
  type        = string
  sensitive   = true
  default     = ""
}
