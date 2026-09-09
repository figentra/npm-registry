/**
 * NPM Registry - Root Variables
 * @file variables.tf
 * @version 1.0.0
 */

variable "cloudflare_api_token" {
  description = "Cloudflare API Token with edit permissions"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for figentra.com"
  type        = string
}