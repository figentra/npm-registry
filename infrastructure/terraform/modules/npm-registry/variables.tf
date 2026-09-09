/**
 * Inputs for the npm-registry module.
 *
 * Resource IDs are never accepted as inputs for resources created by this
 * module. Terraform references the resources directly, which prevents stale
 * IDs from being copied into Wrangler configuration.
 */

variable "account_id" {
  description = "Cloudflare account ID."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-f0-9]{32}$", var.account_id))
    error_message = "account_id must be a 32-character lowercase hexadecimal Cloudflare account ID."
  }
}

variable "zone_id" {
  description = "Cloudflare zone ID containing the registry hostname."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-f0-9]{32}$", var.zone_id))
    error_message = "zone_id must be a 32-character lowercase hexadecimal Cloudflare zone ID."
  }
}

variable "registry_name" {
  description = "Canonical registry and Worker name."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.registry_name))
    error_message = "registry_name may contain only lowercase letters, numbers, and hyphens."
  }
}

variable "registry_domain" {
  description = "Public registry hostname."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.registry_domain))
    error_message = "registry_domain must be a valid lowercase hostname."
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

variable "worker_content_file" {
  description = "Path to the built Worker module."
  type        = string
  nullable    = false
}

variable "worker_main_module" {
  description = "Worker module filename used by Cloudflare upload metadata."
  type        = string
  nullable    = false
}

variable "worker_compatibility_date" {
  description = "Pinned Cloudflare Workers compatibility date."
  type        = string
  nullable    = false
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
  nullable    = false
}
