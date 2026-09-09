/**
 * Compute Resources - Cloudflare Worker Configuration
 * 
 * Worker-related outputs and configuration.
 * 
 * Note: The worker code itself is built and deployed via Wrangler,
 * but this file provides the integration configuration.
 * 
 * @file compute/worker.tf
 * @version 1.0.0
 */

#===============================================================================
# COMPUTE OUTPUTS
#===============================================================================

/**
 * Worker Script ID
 * 
 * The name of the worker script as deployed by Wrangler.
 * Used for logging, monitoring, and API calls.
 * 
 * @output worker_id
 */
output "worker_id" {
  description = "Worker script name/ID"
  value       = var.name
}

/**
 * Worker Default Subdomain
 * 
 * The default Cloudflare Workers subdomain.
 * Format: {worker-name}.{account-id}.workers.dev
 * 
 * @output worker_subdomain
 */
output "worker_subdomain" {
  description = "Worker default subdomain (workers.dev)"
  value       = "${var.name}.${var.account_id}.workers.dev"
}

/**
 * Worker Bindings Configuration
 * 
 * Complete binding configuration for wrangler.toml.
 * This output can be used to generate the wrangler.toml file.
 * 
 * @output worker_bindings
 */
output "worker_bindings" {
  description = "Complete worker bindings for wrangler.toml"
  sensitive   = false
  value = {
    # KV Namespace Binding
    kv_namespaces = [
      {
        binding = "NPM_REGISTRY"
        id      = cloudflare_kv_namespace.npm_registry.id
      }
    ]
    
    # Preview KV Namespace (for staging)
    preview_kv_namespaces = [
      {
        binding = "NPM_REGISTRY"
        preview_id = cloudflare_kv_namespace.npm_registry_preview.id
      }
    ]
    
    # R2 Bucket Binding
    r2_buckets = [
      {
        binding     = "BUCKET"
        bucket_name = cloudflare_r2_bucket.npm_packages.name
      }
    ]
    
    # D1 Database Binding
    d1_databases = [
      {
        binding       = "DB"
        database_id   = cloudflare_d1_database.npm_registry.id
        database_name = cloudflare_d1_database.npm_registry.name
      }
    ]
    
    # Environment Variables
    vars = {
      FALLBACK_REGISTRY_ENDPOINT = "https://registry.npmjs.org"
    }
  }
}
