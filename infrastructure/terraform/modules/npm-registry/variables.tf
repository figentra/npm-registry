variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "name" {
  description = "Name of the npm registry"
  type        = string
  default     = "npm-registry"
}

variable "domain" {
  description = "Custom domain for the registry"
  type        = string
}

variable "zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}

variable "worker_script_path" {
  description = "Path to the built worker script"
  type        = string
  default     = "../npm-registry/dist/index.js"
}

variable "db_location" {
  description = "Location for D1 database"
  type        = string
  default     = "ENAM"
}

variable "r2_location" {
  description = "Location for R2 bucket"
  type        = string
  default     = "ENAM"
}

output "worker_url" {
  description = "URL of the deployed worker"
  value       = cloudflare_workers_domain.npm_registry.hostname
}

output "kv_id" {
  value = cloudflare_kv_namespace.npm_registry.id
}

output "kv_preview_id" {
  value = cloudflare_kv_namespace.npm_registry_preview.id
}

output "d1_database_id" {
  value = cloudflare_d1_database.npm_registry.id
}

output "r2_bucket_name" {
  value = cloudflare_r2_bucket.npm_packages.name
}