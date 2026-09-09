/**
 * NPM Registry - Root Module
 * 
 * Production deployment for Figentra Technologies.
 * 
 * @file main.tf
 * @version 1.0.0
 * @environment production
 */

terraform {
  required_version = ">= 1.7.0"
  
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
  
  # Optional: Terraform Cloud backend
  # cloud {
  #   organization = "figentra"
  #   workspaces {
  #     name = "npm-registry-production"
  #   }
  # }
}

#===============================================================================
# PROVIDERS
#===============================================================================

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

#===============================================================================
# MODULE INVOCATION
#===============================================================================

/**
 * NPM Registry Production Deployment
 * 
 * Creates all resources for the private npm registry.
 */
module "npm_registry" {
  source = "./modules"

  account_id           = var.cloudflare_account_id
  account_name         = "Figentra Technologies L.L.C"
  name                 = "npm-registry"
  name_prefix          = "npm-registry"
  domain               = "npm.figentra.com"
  zone_id              = var.cloudflare_zone_id
  cloudflare_api_token = var.cloudflare_api_token
  environment          = "production"
  d1_location          = "ENAM"
  r2_location          = "ENAM"
  enable_replication   = false
  
  tags = {
    Team        = "Platform"
    CostCenter  = "Engineering"
    Application = "npm-registry"
  }
}

#===============================================================================
# OUTPUTS
#===============================================================================

output "worker_url" {
  description = "Production registry URL"
  value       = module.npm_registry.worker_url
}

output "resource_ids" {
  description = "All created resource IDs"
  value = {
    kv_namespace         = module.npm_registry.kv_namespace_id
    kv_preview_namespace = module.npm_registry.kv_preview_namespace_id
    d1_database         = module.npm_registry.d1_database_id
    r2_bucket           = module.npm_registry.r2_bucket_name
  }
}