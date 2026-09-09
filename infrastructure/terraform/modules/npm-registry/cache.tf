/**
 * Cloudflare Workers KV namespaces.
 *
 * KV stores package metadata/cache information. The preview namespace is
 * intentionally separate so local/preview work cannot overwrite production
 * cache data.
 */

resource "cloudflare_workers_kv_namespace" "npm_registry" {
  account_id = var.account_id
  title      = var.registry_name
}

resource "cloudflare_workers_kv_namespace" "npm_registry_preview" {
  account_id = var.account_id
  title      = "${var.registry_name}-preview"
}
