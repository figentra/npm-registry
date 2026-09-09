/**
 * Data Resources - D1 Database
 * 
 * SQLite-based edge database for tokens and authentication.
 * 
 * Schema:
 * - tokens: Authentication tokens with scopes
 * - packages: Published package metadata
 * - users: User management (optional)
 * 
 * @file data/d1.tf
 * @version 1.0.0
 */

#===============================================================================
# D1 DATABASE
#===============================================================================

/**
 * Registry Database
 * 
 * Stores authentication tokens, package metadata, and audit logs.
 * 
 * Schema tables:
 * - tokenTable: Access tokens with scopes
 * - packageTable: Published packages
 * - auditLog: Change tracking
 * 
 * Performance:
 * - First-read from edge cache
 * - Writes globally consistent (< 500ms)
 * - Automatic backups (Enterprise plan)
 * 
 * @resource cloudflare_d1_database.npm_registry
 * @binding DB
 */
resource "cloudflare_d1_database" "npm_registry" {
  account_id = var.account_id
  name       = "${local.name_prefix}-db"
}

/**
 * Database Backup Schedule
 * 
 * Daily backups with 30-day retention.
 * Requires Enterprise plan.
 */
# Backup configuration would go here
# Currently managed through Cloudflare dashboard
