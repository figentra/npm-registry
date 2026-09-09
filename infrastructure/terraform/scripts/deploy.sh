#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# NPM Registry deployment entry point
# -----------------------------------------------------------------------------
#
# This script deliberately separates the application build from Terraform.
# Terraform should receive an immutable Worker artifact, while the Node build
# system remains responsible for compiling/bundling TypeScript.
#
# Usage:
#   ./scripts/deploy.sh
#
# Required environment:
#   TF_VAR_cloudflare_api_token
#   TF_VAR_cloudflare_account_id
#   TF_VAR_cloudflare_zone_id
# -----------------------------------------------------------------------------

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
PROJECT_ROOT="$(cd -- "${TERRAFORM_DIR}/../.." && pwd)"

log() {
  printf '\n[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
}

fail() {
  printf '\nERROR: %s\n' "$1" >&2
  exit 1
}

command -v terraform >/dev/null 2>&1 || fail "Terraform is not installed or not available on PATH."
command -v pnpm >/dev/null 2>&1 || fail "pnpm is required to build the Worker."

[[ -n "${TF_VAR_cloudflare_api_token:-}" ]] || fail "TF_VAR_cloudflare_api_token is not set."
[[ -n "${TF_VAR_cloudflare_account_id:-}" ]] || fail "TF_VAR_cloudflare_account_id is not set."
[[ -n "${TF_VAR_cloudflare_zone_id:-}" ]] || fail "TF_VAR_cloudflare_zone_id is not set."

log "Building Worker application"
cd "$PROJECT_ROOT"
pnpm run build

WORKER_FILE="${TERRAFORM_DIR}/../../dist/worker.js"
[[ -f "$WORKER_FILE" ]] || fail "Worker build did not produce ${WORKER_FILE}. Update worker_content_file if your build uses another output path."

log "Initializing Terraform"
cd "$TERRAFORM_DIR"
terraform init

log "Validating Terraform configuration"
terraform fmt -check -recursive
terraform validate

log "Planning production infrastructure"
terraform plan -out=tfplan

log "Applying production infrastructure"
terraform apply tfplan

log "Deployment complete"
terraform output
