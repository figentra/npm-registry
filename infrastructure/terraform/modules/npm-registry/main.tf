# KV Namespaces
resource "cloudflare_kv_namespace" "npm_registry" {
  account_id = var.account_id
  title      = var.name
}

resource "cloudflare_kv_namespace" "npm_registry_preview" {
  account_id = var.account_id
  title      = "${var.name}_preview"
}

# R2 Bucket
resource "cloudflare_r2_bucket" "npm_packages" {
  account_id = var.account_id
  name       = "${var.name}-packages"
  location   = var.r2_location
}

# D1 Database
resource "cloudflare_d1_database" "npm_registry" {
  account_id = var.account_id
  name       = "${var.name}-db"
}

# Worker Script - Managed via wrangler, but can be referenced for bindings
# Note: The actual worker code is deployed via wrangler CLI
# This creates the bindings configuration

locals {
  worker_bindings = {
    kv_namespaces = [
      {
        binding = "NPM_REGISTRY"
        id      = cloudflare_kv_namespace.npm_registry.id
      }
    ]
    r2_buckets = [
      {
        binding    = "BUCKET"
        bucket_name = cloudflare_r2_bucket.npm_packages.name
      }
    ]
    d1_databases = [
      {
        binding       = "DB"
        database_id   = cloudflare_d1_database.npm_registry.id
        database_name = cloudflare_d1_database.npm_registry.name
      }
    ]
  }
}

# Output the bindings for use in wrangler.toml
resource "terraform_data" "worker_bindings" {
  provisioner "local-exec" {
    command = <<-EOT
      echo '${jsonencode(local.worker_bindings)}' > ${path.module}/worker-bindings.json
    EOT
  }
}

# Worker Custom Domain
resource "cloudflare_workers_domain" "npm_registry" {
  account_id = var.account_id
  hostname   = var.domain
  service    = cloudflare_workers_script.npm_registry.name
  zone_id    = var.zone_id
}