/**
 * Production outputs.
 *
 * Outputs expose only values useful to operators and deployment tooling.
 * Secrets are deliberately never returned from Terraform outputs.
 */

output "worker_url" {
  description = "Public npm registry URL."
  value       = module.npm_registry.worker_url
}

output "worker_name" {
  description = "Cloudflare Worker name."
  value       = module.npm_registry.worker_name
}

output "kv_namespace_id" {
  description = "Production KV namespace ID."
  value       = module.npm_registry.kv_namespace_id
}

output "kv_preview_namespace_id" {
  description = "Preview KV namespace ID."
  value       = module.npm_registry.kv_preview_namespace_id
}

output "d1_database_id" {
  description = "D1 database ID."
  value       = module.npm_registry.d1_database_id
}

output "r2_bucket_name" {
  description = "R2 package storage bucket name."
  value       = module.npm_registry.r2_bucket_name
}
