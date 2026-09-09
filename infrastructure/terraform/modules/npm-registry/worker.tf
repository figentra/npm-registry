/**
 * Cloudflare Worker deployment.
 *
 * The previous implementation called `npx wrangler deploy` from a Terraform
 * `local-exec` provisioner. That created two independent sources of truth:
 * Terraform created the KV namespace while Wrangler could still use a stale
 * namespace ID from another configuration file. The observed failure was
 * exactly this condition: the Worker upload referenced a KV namespace that
 * did not exist in the account.
 *
 * Terraform now owns the Worker binding configuration directly. Resource IDs
 * are references to the namespaces created above, so an ID cannot silently
 * drift from Terraform state.
 */

resource "cloudflare_workers_script" "npm_registry" {
  account_id = var.account_id
  script_name = local.worker_name

  # The build is intentionally performed outside Terraform. This keeps the
  # infrastructure layer deterministic and lets the application build use
  # the project's existing Node/TypeScript toolchain.
  content_file   = var.worker_content_file
  content_sha256 = filesha256(var.worker_content_file)
  main_module    = var.worker_main_module

  compatibility_date  = var.worker_compatibility_date
  compatibility_flags = ["nodejs_compat"]
  usage_model         = "standard"

  observability = {
    enabled            = true
    head_sampling_rate = 1
    logs = {
      enabled          = true
      invocation_logs  = true
      persist          = true
      destinations     = ["cloudflare"]
      head_sampling_rate = 1
    }
  }

  bindings = [
    {
      name         = "NPM_REGISTRY"
      type         = "kv_namespace"
      namespace_id = cloudflare_workers_kv_namespace.npm_registry.id
    },
    {
      name         = "DB"
      type         = "d1"
      database_id  = cloudflare_d1_database.npm_registry.id
    },
    {
      name        = "BUCKET"
      type        = "r2_bucket"
      bucket_name = cloudflare_r2_bucket.npm_packages.name
    },
    {
      name = "FALLBACK_REGISTRY_ENDPOINT"
      type = "plain_text"
      text = "https://registry.npmjs.org"
    }
  ]
}
