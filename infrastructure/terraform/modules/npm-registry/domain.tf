/**
 * Public Worker custom domain.
 *
 * The domain is managed by Terraform and depends on the Worker resource, so
 * the hostname can never be attached to a Worker that Terraform has not yet
 * created.
 */

resource "cloudflare_workers_custom_domain" "npm_registry" {
  account_id = var.account_id
  zone_id    = var.zone_id
  hostname   = var.registry_domain
  service    = cloudflare_workers_script.npm_registry.script_name

  depends_on = [cloudflare_workers_script.npm_registry]
}
