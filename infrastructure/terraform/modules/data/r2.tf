/**
 * Data Resources - R2 Bucket
 * S3-compatible object storage for package tarballs.
 * @file data/r2.tf
 * @version 1.0.0
 */

#===============================================================================
# R2 BUCKET
#===============================================================================

resource "cloudflare_r2_bucket" "npm_packages" {
  account_id = var.account_id
  name       = "${var.name_prefix}-packages"
  location   = var.r2_location
}
