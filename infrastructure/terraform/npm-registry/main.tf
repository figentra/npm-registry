terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "domain" {
  description = "Domain for the npm registry"
  type        = string
  default     = "npm.figentra.com"
}

variable "zone_id" {
  description = "Cloudflare Zone ID for the domain"
  type        = string
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Module for reusable npm-registry infrastructure
module "npm_registry" {
  source = "./modules/npm-registry"

  account_id = var.cloudflare_account_id
  name       = "npm-registry"
  domain     = var.domain
  zone_id    = var.zone_id
}

# Output the worker URL
output "worker_url" {
  value = "https://${var.domain}"
}

output "kv_namespace_id" {
  value = module.npm_registry.kv_id
}

output "kv_preview_namespace_id" {
  value = module.npm_registry.kv_preview_id
}

output "d1_database_id" {
  value = module.npm_registry.d1_database_id
}

output "r2_bucket_name" {
  value = module.npm_registry.r2_bucket_name
}