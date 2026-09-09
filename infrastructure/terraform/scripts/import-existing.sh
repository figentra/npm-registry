#!/usr/bin/env bash

# Import resources that already exist in Cloudflare into this module's state.
# Run only when adopting an existing installation; normal deployments do not
# need this script.

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
cd "$TERRAFORM_DIR"

: "${TF_VAR_cloudflare_account_id:?TF_VAR_cloudflare_account_id must be set}"

ACCOUNT_ID="$TF_VAR_cloudflare_account_id"

terraform import module.npm_registry.cloudflare_workers_kv_namespace.npm_registry \
  "${ACCOUNT_ID}/48285cc2cdbf40aaa941355d2b3595b9" || true

terraform import module.npm_registry.cloudflare_workers_kv_namespace.npm_registry_preview \
  "${ACCOUNT_ID}/d34d6ed5afae4f66a5ca6cecc5017eff" || true

terraform import module.npm_registry.cloudflare_d1_database.npm_registry \
  "${ACCOUNT_ID}/d7993d20-638f-4c21-b03d-f88df18b0e94" || true

terraform import module.npm_registry.cloudflare_r2_bucket.npm_packages \
  "${ACCOUNT_ID}/npm-registry-packages" || true

# The Worker and custom domain must be imported only if they already exist.
# Uncomment and provide the real remote IDs when adopting an existing Worker.
# terraform import module.npm_registry.cloudflare_workers_script.npm_registry "${ACCOUNT_ID}/npm-registry"
# terraform import module.npm_registry.cloudflare_workers_custom_domain.npm_registry "<custom-domain-id>"
