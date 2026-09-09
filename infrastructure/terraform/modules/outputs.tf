/**
 * NPM Registry - Outputs
 * @file outputs.tf
 * @version 1.0.0
 */

output "worker_url" {
  description = "Custom domain URL"
  value       = "https://${var.domain}"
}

output "kv_namespace_id" {
  description = "Production KV namespace ID"
  value       = cloudflare_workers_kv_namespace.npm_registry.id
}

output "kv_preview_namespace_id" {
  description = "Preview KV namespace ID"
  value       = cloudflare_workers_kv_namespace.npm_registry_preview.id
}

output "d1_database_id" {
  description = "D1 database ID"
  value       = cloudflare_d1_database.npm_registry.id
}

output "d1_database_name" {
  description = "D1 database name"
  value       = cloudflare_d1_database.npm_registry.name
}

output "r2_bucket_name" {
  description = "R2 bucket name"
  value       = cloudflare_r2_bucket.npm_packages.name
}

# output "worker_domain_id" {
#   description = "Worker domain ID"
#   value       = cloudflare_workers_domain.npm_registry.id
# }

output "worker_bindings" {
  description = "Worker bindings configuration for wrangler.toml"
  value = {
    kv_namespaces = [
      {
        binding = "NPM_REGISTRY"
        id      = cloudflare_workers_kv_namespace.npm_registry.id
      }
    ]
    preview_kv_namespaces = [
      {
        binding = "NPM_REGISTRY"
        preview_id = cloudflare_workers_kv_namespace.npm_registry_preview.id
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
