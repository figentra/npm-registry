/**
 * NPM Registry - Resources
 * All Cloudflare resources for the npm registry.
 * @file resources.tf
 * @version 1.0.0
 */

#===============================================================================
# KV NAMESPACES
#===============================================================================

resource "cloudflare_workers_kv_namespace" "npm_registry" {
  account_id = var.account_id
  title      = var.name_prefix
}

resource "cloudflare_workers_kv_namespace" "npm_registry_preview" {
  account_id = var.account_id
  title      = "${var.name_prefix}-preview"
}

#===============================================================================
# D1 DATABASE
#===============================================================================

resource "cloudflare_d1_database" "npm_registry" {
  account_id = var.account_id
  name       = "${var.name_prefix}-db"
}

#===============================================================================
# R2 BUCKET
#===============================================================================

resource "cloudflare_r2_bucket" "npm_packages" {
  account_id = var.account_id
  name       = "${var.name_prefix}-packages"
  # Note: Location is auto-assigned by Cloudflare based on account
  # Using lifecycle ignore to prevent perpetual diff
  lifecycle {
    ignore_changes = [
      location
    ]
  }
}

#===============================================================================
# WORKER SCRIPT
#===============================================================================

# Deploy worker script via Wrangler from Terraform
resource "null_resource" "worker_deploy" {
  depends_on = [
    cloudflare_workers_kv_namespace.npm_registry,
    cloudflare_workers_kv_namespace.npm_registry_preview,
    cloudflare_d1_database.npm_registry,
    cloudflare_r2_bucket.npm_packages
  ]

  triggers = {
    # Redeploy when bindings change
    kv_namespace_id         = cloudflare_workers_kv_namespace.npm_registry.id
    kv_preview_namespace_id = cloudflare_workers_kv_namespace.npm_registry_preview.id
    d1_database_id          = cloudflare_d1_database.npm_registry.id
    r2_bucket_name          = cloudflare_r2_bucket.npm_packages.name
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/../../"
    command     = "npx wrangler deploy --minify"
    environment = {
      CLOUDFLARE_API_TOKEN = var.cloudflare_api_token
    }
  }
}

#===============================================================================
# WORKER DOMAIN (Custom Domain)
#===============================================================================

resource "cloudflare_workers_domain" "npm_registry" {
  depends_on = [null_resource.worker_deploy]

  account_id  = var.account_id
  hostname    = var.domain
  service     = var.name_prefix
  zone_id     = var.zone_id
  environment = "production"
}
