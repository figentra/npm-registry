/**
 * NPM Registry Infrastructure
 *
 * Centralized Terraform and provider version constraints.
 * Keeping these constraints in one file makes upgrades deliberate and
 * prevents individual resource files from carrying version policy.
 */
terraform {
  required_version = ">= 1.7.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.24"
    }
  }
}
