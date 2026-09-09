/**
 * Root input variables for the production npm registry deployment.
 *
 * Keep this file focused on deployment-level configuration. Resource-specific
 * implementation details belong inside modules/npm-registry.
 */

variable "cloudflare_api_token" {
  description = "Cloudflare API token used by Terraform to manage the account."
  type        = string
  sensitive   = true
  nullable    = false
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID that owns the npm registry resources."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-f0-9]{32}$", var.cloudflare_account_id))
    error_message = "cloudflare_account_id must be a 32-character lowercase hexadecimal Cloudflare account ID."
  }
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID for the figentra.com zone."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-f0-9]{32}$", var.cloudflare_zone_id))
    error_message = "cloudflare_zone_id must be a 32-character lowercase hexadecimal Cloudflare zone ID."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "production"
  nullable    = false

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "environment must be development, staging, or production."
  }
}

variable "registry_name" {
  description = "Canonical name used for the Worker and resource naming."
  type        = string
  default     = "npm-registry"
  nullable    = false

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.registry_name))
    error_message = "registry_name may contain only lowercase letters, numbers, and hyphens."
  }
}

variable "registry_domain" {
  description = "Public hostname for the npm registry."
  type        = string
  default     = "npm.figentra.com"
  nullable    = false

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.registry_domain))
    error_message = "registry_domain must be a valid lowercase hostname."
  }
}

variable "worker_content_file" {
  description = "Path, relative to this Terraform root, to the already-built Worker JavaScript module."
  type        = string
  default     = "../../dist/worker.js"
  nullable    = false
}

variable "worker_main_module" {
  description = "Filename used as the Worker module entry point in the upload metadata."
  type        = string
  default     = "worker.js"
  nullable    = false
}

variable "worker_compatibility_date" {
  description = "Cloudflare Workers compatibility date pinned for deterministic runtime behavior."
  type        = string
  default     = "2026-09-09"
  nullable    = false
}
