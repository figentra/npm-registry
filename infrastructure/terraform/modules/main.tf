/**
 * NPM Registry - Terraform Module
 * @version 1.0.0
 */

terraform {
  required_version = ">= 1.7.0"
  
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5.0"
    }
  }
}

# Local values
locals {
  module_name    = "npm-registry"
  module_version = "1.0.0"
  name_prefix    = var.name
  
  common_tags = {
    Project     = var.name
    Environment = var.environment
    ManagedBy   = "terraform"
    Module      = local.module_name
    Version     = local.module_version
  }
}
