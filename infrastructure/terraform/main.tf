/**
 * NPM Registry - Production Root Module
 *
 * This file intentionally contains only composition. Resource implementation
 * lives in the reusable npm-registry module so the production environment is
 * easy to understand and future environments can reuse the same module.
 */

module "npm_registry" {
  source = "./modules/npm-registry"

  account_id             = var.cloudflare_account_id
  zone_id                = var.cloudflare_zone_id
  registry_name          = var.registry_name
  registry_domain        = var.registry_domain
  environment            = var.environment
  # Resolve the artifact once at the root so the child module receives an
  # absolute path. Terraform file functions are evaluated relative to the
  # module where they are called, so this avoids path ambiguity.
  worker_content_file    = abspath("${path.root}/${var.worker_content_file}")
  worker_main_module     = var.worker_main_module
  worker_compatibility_date = var.worker_compatibility_date

  tags = {
    Team        = "Platform"
    CostCenter  = "Engineering"
    Application = "npm-registry"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
