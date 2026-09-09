/**
 * NPM Registry reusable module.
 *
 * The module is intentionally small: it owns the registry's storage,
 * Worker, and public domain. Each concern is separated into its own file,
 * while the module itself remains a single deployable unit.
 */

locals {
  worker_name = var.registry_name

  common_tags = merge(
    {
      Project     = var.registry_name
      Environment = var.environment
      ManagedBy   = "terraform"
      Component   = "npm-registry"
    },
    var.tags,
  )
}
