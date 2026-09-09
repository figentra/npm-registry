/**
 * Data Resources - D1 Database
 * SQLite-based edge database for tokens and authentication.
 * @file data/d1.tf
 * @version 1.0.0
 */

#===============================================================================
# D1 DATABASE
#===============================================================================

resource "cloudflare_d1_database" "npm_registry" {
  account_id = var.account_id
  name       = "${var.name_prefix}-db"
}
