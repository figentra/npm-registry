/**
 * Data Resources - R2 Bucket
 * 
 * S3-compatible object storage for package tarballs.
 * 
 * Features:
 * - Zero egress fees
 * - Automatic replication (optional)
 * - S3-compatible API
 * - CDN integration
 * 
 * @file data/r2.tf
 * @version 1.0.0
 */

#===============================================================================
# R2 BUCKET
#===============================================================================

/**
 * Package Storage Bucket
 * 
 * Stores npm package tarballs (.tgz files).
 * Named format: {registry-name}-packages
 * 
 * Storage characteristics:
 * - No minimum storage duration
 * - No egress fees
 * - Automatic multipart upload for large files
 * 
 * @resource cloudflare_r2_bucket.npm_packages
 * @binding BUCKET
 */
resource "cloudflare_r2_bucket" "npm_packages" {
  account_id = var.account_id
  name       = "${local.name_prefix}-packages"
  location   = var.r2_location
  
  # Lifecycle rules can be added here for automatic cleanup
  # CORS policies for browser access
  # Access policies for public/private access
}

/**
 * Bucket Lifecycle Rule
 * 
 * Automatically cleanup old package versions.
 * Keeps only the last N versions of each package.
 * 
 * Commented out until needed:
 */
# resource "cloudflare_r2_bucket_lifecycle_rule" "cleanup_old_versions" {
#   bucket      = cloudflare_r2_bucket.npm_packages.name
#   account_id  = var.account_id
#   enabled     = true
# 
#   delete_after_days = 365  # Cleanup after 1 year
# }
