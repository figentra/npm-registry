/**
 * Networking Resources - Custom Domain
 * DNS and domain configuration for the npm registry.
 * @file networking/dns.tf
 * @version 1.0.0
 */

#===============================================================================
# WORKER CUSTOM DOMAIN
#===============================================================================

resource "cloudflare_workers_domain" "npm_registry" {
  account_id = var.account_id
  hostname   = var.domain
  service    = var.name_prefix
  zone_id    = var.zone_id
}
