/**
 * Outputs from the npm-registry module.
 *
 * IDs are exposed because they are useful for diagnostics and integrations,
 * but no credentials are returned.
 */

output "worker_name" {
  description = "Cloudflare Worker name."
  value       = cloudflare_workers_script.npm_registry.script_name
}

output "worker_url" {
  description = "Public registry URL."
  value       = "https://${var.registry_domain}"
}

output "worker_id" {
  description = "Cloudflare Worker resource ID."
  value       = cloudflare_workers_script.npm_registry.id
}

output "kv_namespace_id" {
  description = "Production KV namespace ID."
  value       = cloudflare_workers_kv_namespace.npm_registry.id
}

output "kv_preview_namespace_id" {
  description = "Preview KV namespace ID."
  value       = cloudflare_workers_kv_namespace.npm_registry_preview.id
}

output "d1_database_id" {
  description = "D1 database ID."
  value       = cloudflare_d1_database.npm_registry.id
}

output "r2_bucket_name" {
  description = "R2 package storage bucket name."
  value       = cloudflare_r2_bucket.npm_packages.name
}

output "custom_domain_id" {
  description = "Cloudflare custom domain resource ID."
  value       = cloudflare_workers_custom_domain.npm_registry.id
}
