/**
 * Networking Resources - Custom Domain
 * 
 * DNS and domain configuration for the npm registry.
 * 
 * @file networking/dns.tf
 * @version 1.0.0
 */

#===============================================================================
# WORKER CUSTOM DOMAIN
#===============================================================================

/**
 * Custom Domain for npm-registry Worker
 * 
 * Creates a DNS record and configures SSL/TLS automatically.
 * The custom domain allows the worker to be accessed at a branded URL.
 * 
 * SSL Configuration:
 * - Automatic certificate provisioning
 * - Automatic renewal
 * - HTTPS-only by default
 * 
 * @resource cloudflare_workers_domain.npm_registry
 * @pattern npm.figentra.com
 */
resource "cloudflare_workers_domain" "npm_registry" {
  account_id = var.account_id
  hostname   = var.domain
  service    = local.worker_script_name
  zone_id    = var.zone_id
  
  # SSL mode is automatically managed by Cloudflare
  # Certificate is provisioned automatically
  
  # Wait for the worker resource to be ready
  depends_on = [cloudflare_kv_namespace.npm_registry]
}

/**
 * DNS Record (if custom domain setup requires manual DNS)
 * 
 * Uncomment if you need to create a CNAME record manually.
 * Usually not needed when using cloudflare_workers_domain.
 */
# resource "cloudflare_record" "npm_registry" {
#   zone_id = var.zone_id
#   name    = "npm"
#   type    = "CNAME"
#   content = "npm-registry.${var.account_id}.workers.dev"
#   proxied = true
# }
