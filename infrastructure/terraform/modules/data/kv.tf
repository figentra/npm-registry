/**
 * Data Resources - KV Namespaces
 * 
 * KV Namespaces for caching package metadata and configuration.
 * 
 * @file data/kv.tf
 * @version 1.0.0
 */

#===============================================================================
# KV NAMESPACES
#===============================================================================

/**
 * Production KV Namespace
 * 
 * Stores package metadata, cache data, and configuration.
 * This is the primary namespace for production traffic.
 * 
 * @resource cloudflare_kv_namespace.npm_registry
 * @binding NPM_REGISTRY
 */
resource "cloudflare_kv_namespace" "npm_registry" {
  account_id = var.account_id
  title      = var.name_prefix
  
  # Note: KV namespaces are global and replicated automatically
}

/**
 * Preview KV Namespace
 * 
 * Separate namespace for development and preview deployments.
 * Allows testing without affecting production data.
 * 
 * @resource cloudflare_kv_namespace.npm_registry_preview
 */
resource "cloudflare_kv_namespace" "npm_registry_preview" {
  account_id = var.account_id
  title      = "${var.name_prefix}-preview"
}
