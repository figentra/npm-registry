/**
 * NPM Registry - Terraform Module
 * @version 1.0.0
 */

terraform {
  required_version = ">= 1.7.0"
  
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# Local values
locals {
  module_name    = "npm-registry"
  module_version = "1.0.0"
  name_prefix    = var.name
  
  common_tags = {
    Project     = var.name
    Environment = var.environment
    ManagedBy   = "terraform"
    Module      = local.module_name
    Version     = local.module_version
  }
}

# Outputs
output "worker_url" {
  description = "Custom domain URL"
  value       = "https://${var.domain}"
}

output "kv_namespace_id" {
  description = "Production KV namespace ID"
  value       = cloudflare_kv_namespace.npm_registry.id
}

output "kv_preview_namespace_id" {
  description = "Preview KV namespace ID"
  value       = cloudflare_kv_namespace.npm_registry_preview.id
}

output "d1_database_id" {
  description = "D1 database ID"
  value       = cloudflare_d1_database.npm_registry.id
}

output "r2_bucket_name" {
  description = "R2 bucket name"
  value       = cloudflare_r2_bucket.npm_packages.name
}

/**
 * Worker Bindings
 * 
 * Complete binding configuration for wrangler.toml generation.
 * Use this output to automatically update wrangler.toml.
 * 
 * @output worker_bindings
 */
output "worker_bindings" {
  description = "Worker bindings configuration"
  value = {
    kv_namespaces = [
      {
        binding = "NPM_REGISTRY"
        id      = cloudflare_kv_namespace.npm_registry.id
      }
    ]
    r2_buckets = [
      {
        binding     = "BUCKET"
        bucket_name = cloudflare_r2_bucket.npm_packages.name
      }
    ]
    d1_databases = [
      {
        binding       = "DB"
        database_id   = cloudflare_d1_database.npm_registry.id
        database_name = cloudflare_d1_database.npm_registry.name
      }
    ]
    vars = {
      FALLBACK_REGISTRY_ENDPOINT = "https://registry.npmjs.org"
    }
  }
}
