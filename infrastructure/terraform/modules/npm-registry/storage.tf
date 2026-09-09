/**
 * Cloudflare R2 package storage.
 *
 * Package tarballs are durable objects and therefore live outside KV. The
 * location is intentionally left under Cloudflare account control; this also
 * avoids an unnecessary migration when Cloudflare reports the bucket's
 * effective location after creation.
 */

resource "cloudflare_r2_bucket" "npm_packages" {
  account_id = var.account_id
  name       = "${var.registry_name}-packages"

  lifecycle {
    # Cloudflare can assign/normalize the bucket location after creation.
    ignore_changes = [location]
  }
}
