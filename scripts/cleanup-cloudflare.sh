#!/bin/bash
#==============================================================================
# Cloudflare Resource Cleanup Script
#==============================================================================
# WARNING: This script will DELETE ALL npm-registry related resources
# from Cloudflare. Use with extreme caution!
# Usage: ./cleanup-cloudflare.sh [ACCOUNT_ID] [API_TOKEN]
#==============================================================================

set -e

RED='\033[0;31m' YELLOW='\033[1;33m' GREEN='\033[0;32m' NC='\033[0m'

ACCOUNT_ID="${1:-$CLOUDFLARE_ACCOUNT_ID}"
API_TOKEN="${2:-$CLOUDFLARE_API_TOKEN}"
REGISTRY_NAME="${3:-npm-registry}"

if [[ -z "$ACCOUNT_ID" ]] || [[ -z "$API_TOKEN" ]]; then
    echo "ERROR: Account ID and API Token required"
    exit 1
fi

echo "WARNING: This will DELETE ALL Cloudflare resources matching '$REGISTRY_NAME'"
read -p "Type 'yes' to continue: " confirm
[[ "$confirm" == "yes" ]] || exit 1

CF_API="https://api.cloudflare.com/client/v4"
AUTH="Authorization: Bearer $API_TOKEN"

delete_resource() {
    local url=$1 name=$2
    echo -n "Deleting $name... "
    curl -s -X DELETE "$url" -H "$AUTH" -H "Content-Type: application/json" | grep -q '"success":true' && echo "✓" || echo "✗"
}

echo "=== Cleaning up Cloudflare Resources ==="

# Delete KV Namespaces
echo "KV Namespaces:"
curl -s "$CF_API/accounts/$ACCOUNT_ID/storage/kv/namespaces" -H "$AUTH" | \
    jq -r ".result[] | select(.title | contains(\"$REGISTRY_NAME\")) | [.id,.title] | @tsv" 2>/dev/null | \
    while IFS=$'\t' read -r id title; do delete_resource "$CF_API/accounts/$ACCOUNT_ID/storage/kv/namespaces/$id" "$title"; done || echo "  None found"

# Delete D1 Databases  
echo "D1 Databases:"
curl -s "$CF_API/accounts/$ACCOUNT_ID/d1/database" -H "$AUTH" | \
    jq -r ".result[] | select(.name | contains(\"$REGISTRY_NAME\")) | [.uuid,.name] | @tsv" 2>/dev/null | \
    while IFS=$'\t' read -r uuid name; do delete_resource "$CF_API/accounts/$ACCOUNT_ID/d1/database/$uuid" "$name"; done || echo "  None found"

# Delete R2 Buckets
echo "R2 Buckets:"
curl -s "$CF_API/accounts/$ACCOUNT_ID/r2/buckets" -H "$AUTH" | \
    jq -r ".buckets[] | select(.name | contains(\"$REGISTRY_NAME\")) | .name" 2>/dev/null | \
    while read -r bucket; do delete_resource "$CF_API/accounts/$ACCOUNT_ID/r2/buckets/$bucket" "$bucket"; done || echo "  None found"

# Delete Worker Domains
echo "Worker Domains:"
curl -s "$CF_API/accounts/$ACCOUNT_ID/workers/domains" -H "$AUTH" | \
    jq -r ".result[] | select(.service | contains(\"$REGISTRY_NAME\")) | [.id,.hostname] | @tsv" 2>/dev/null | \
    while IFS=$'\t' read -r id hostname; do delete_resource "$CF_API/accounts/$ACCOUNT_ID/workers/domains/$id" "$hostname"; done || echo "  None found"

# Delete Worker Scripts
echo "Worker Scripts:"
curl -s "$CF_API/accounts/$ACCOUNT_ID/workers/services" -H "$AUTH" | \
    jq -r ".result[] | select(.id | contains(\"$REGISTRY_NAME\")) | .id" 2>/dev/null | \
    while read -r script; do delete_resource "$CF_API/accounts/$ACCOUNT_ID/workers/services/$script" "$script"; done || echo "  None found"

echo "=== Cleanup Complete ==="