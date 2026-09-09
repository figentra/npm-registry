/**
 * Provider configuration.
 *
 * Authentication is intentionally supplied through a sensitive Terraform
 * variable. For CI/CD, prefer TF_VAR_cloudflare_api_token or a secret store
 * instead of committing credentials to files.
 */
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
