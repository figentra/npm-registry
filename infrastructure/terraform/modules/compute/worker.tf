/**
 * Compute Resources - Cloudflare Worker Configuration
 * Worker-related outputs and configuration.
 * @file compute/worker.tf
 * @version 1.0.0
 */

#===============================================================================
# COMPUTE OUTPUTS
#===============================================================================

output "worker_id" {
  description = "Worker script name/ID"
  value       = var.name_prefix
}

output "worker_subdomain" {
  description = "Worker default subdomain (workers.dev)"
  value       = "${var.name_prefix}.${var.account_id}.workers.dev"
}

output "worker_bindings" {
  description = "Complete worker bindings for wrangler.toml"
  sensitive   = false
  value = {
    kv_namespaces = [
      {
        binding = "NPM_REGISTRY"
        id      = cloudflare_kv_namespace.npm_registry.id
      }
    ]
    preview_kv_namespaces = [
      {
        binding = "NPM_REGISTRY"
        preview_id = cloudflare_kv_namespace.npm_registry_preview.id
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
