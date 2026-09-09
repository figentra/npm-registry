/**
 * Cloudflare D1 database.
 *
 * D1 is kept as an independent resource so database lifecycle changes remain
 * isolated from object storage and Worker deployment changes.
 */

resource "cloudflare_d1_database" "npm_registry" {
  account_id = var.account_id
  name       = "${var.registry_name}-db"
}
