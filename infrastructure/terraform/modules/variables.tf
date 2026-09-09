/**
 * NPM Registry - Terraform Variables
 * @version 1.0.0
 */

# Required Variables
variable "account_id" {
  description = "Cloudflare Account ID (32 characters)"
  type        = string
  
  validation {
    condition     = length(var.account_id) == 32
    error_message = "Account ID must be exactly 32 characters."
  }
}

variable "account_name" {
  description = "Cloudflare Account Name"
  type        = string
  default     = "Figentra Technologies"
}

variable "name" {
  description = "Registry name (lowercase, hyphens, numbers only)"
  type        = string
  default     = "npm-registry"
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "Name must be lowercase alphanumeric with hyphens only."
  }
}

variable "domain" {
  description = "Custom domain for registry"
  type        = string
  default     = "npm.figentra.com"
  
  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.domain))
    error_message = "Domain must be valid FQDN."
  }
}

variable "zone_id" {
  description = "Cloudflare Zone ID for domain"
  type        = string
}

# Optional Variables
variable "environment" {
  description = "Environment: development, staging, production"
  type        = string
  default     = "production"
  
  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be development, staging, or production."
  }
}

variable "module_version" {
  description = "Module version tag"
  type        = string
  default     = "1.0.0"
}

variable "d1_location" {
  description = "D1 database location: WEUR, EEUR, ENAM, WNAM, APAC, OC"
  type        = string
  default     = "ENAM"
}

variable "r2_location" {
  description = "R2 bucket location: WEUR, EEUR, ENAM, WNAM, APAC, OC"
  type        = string
  default     = "ENAM"
}

variable "enable_replication" {
  description = "Enable R2 replication"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional resource tags"
  type        = map(string)
  default     = {}
}