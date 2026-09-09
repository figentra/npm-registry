terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# Figentra npm-registry deployment
module "npm_registry" {
  source = "./modules/npm-registry"

  account_id = var.cloudflare_account_id
  name       = "npm-registry"
  domain     = "npm.figentra.com"
  zone_id    = var.cloudflare_zone_id
}

# Variables
variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_account_id" {
  type = string
}

variable "cloudflare_zone_id" {
  type = string
}

# Provider
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Outputs
output "worker_url" {
  value = module.npm_registry.worker_url
}

output "kv_namespace_id" {
  value = module.npm_registry.kv_id
}

output "d1_database_id" {
  value = module.npm_registry.d1_database_id
}

output "r2_bucket_name" {
  value = module.npm_registry.r2_bucket_name
}