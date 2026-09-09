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
  location   = var.r2_location
}

#===============================================================================
# WORKER DOMAIN
#===============================================================================

resource "cloudflare_workers_domain" "npm_registry" {
  account_id = var.account_id
  hostname   = var.domain
  service    = var.name_prefix
  zone_id    = var.zone_id
}
