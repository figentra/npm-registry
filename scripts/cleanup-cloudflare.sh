#!/bin/bash
#==============================================================================
# Cloudflare Resource Cleanup Script (Wrangler-based)
#==============================================================================
# WARNING: This will DELETE ALL npm-registry related resources!
# Usage: ./cleanup-cloudflare.sh [REGISTRY_NAME]
# Default REGISTRY_NAME: npm-registry
#==============================================================================

set -e

RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m' NC='\033[0m'
REGISTRY_NAME="${1:-npm-registry}"

echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║  ⚠️  WARNING: DESTRUCTIVE OPERATION                        ║${NC}"
echo -e "${RED}║                                                            ║${NC}"
echo -e "${RED}║  This will DELETE resources matching: ${REGISTRY_NAME}*          ${NC}"
echo -e "${RED}║                                                            ║${NC}"
echo -e "${RED}║  • KV Namespaces                                           ║${NC}"
echo -e "${RED}║  • D1 Database                                             ║${NC}"
echo -e "${RED}║  • R2 Bucket                                               ║${NC}"
echo -e "${RED}║  • Worker Script                                           ║${NC}"
echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
read -p "Type 'delete' to continue: " confirm
[[ "$confirm" == "delete" ]] || { echo "Aborted."; exit 1; }

echo ""
echo "🗑️  Deleting resources..."
echo ""

# Get IDs for resources
KV_NAMESPACES=$(wrangler kv namespace list 2>/dev/null | jq -r ".[] | select(.title | contains(\"$REGISTRY_NAME\")) | [.id, .title] | @tsv" 2>/dev/null || echo "")

# Delete KV Namespaces
echo "1. Deleting KV Namespaces..."
if [[ -n "$KV_NAMESPACES" ]]; then
    echo "$KV_NAMESPACES" | while IFS=$'\t' read -r id title; do
        echo "   Deleting $title..."
        wrangler kv namespace delete --namespace-id "$id" 2>/dev/null || echo "   Failed to delete $title (may not exist)"
    done
else
    echo "   No KV namespaces found matching '$REGISTRY_NAME'"
fi

# Delete D1 Database
echo "2. Deleting D1 Database..."
D1_DB="${REGISTRY_NAME}-db"
wrangler d1 delete "$D1_DB" -y 2>/dev/null || echo "   $D1_DB: already deleted or error"

# Delete R2 Bucket
echo "3. Deleting R2 Bucket..."
R2_BUCKET="${REGISTRY_NAME}-packages"
wrangler r2 bucket delete "$R2_BUCKET" 2>/dev/null || echo "   $R2_BUCKET: already deleted or error"

# Delete Worker Script
echo "4. Deleting Worker Script..."
wrangler delete "$REGISTRY_NAME" 2>/dev/null || echo "   $REGISTRY_NAME worker: already deleted or error"

echo ""
echo -e "${GREEN}✓ Cleanup complete!${NC}"
echo ""
echo "Verifying..."
sleep 2

# Final verification
echo ""
echo "=== VERIFICATION ==="
KV_REMAINING=$(wrangler kv namespace list 2>/dev/null | jq -r ".[].title" | grep -i "$REGISTRY_NAME" | wc -l)
D1_REMAINING=$(wrangler d1 list 2>/dev/null | grep "$REGISTRY_NAME" | wc -l)
R2_REMAINING=$(wrangler r2 bucket list 2>/dev/null | grep "$REGISTRY_NAME" | wc -l)

[[ "$KV_REMAINING" -eq 0 ]] && echo "   ✅ KV Namespaces: Clean" || echo "   ⚠️  KV Namespaces: $KV_REMAINING remaining"
[[ "$D1_REMAINING" -eq 0 ]] && echo "   ✅ D1 Database: Clean" || echo "   ⚠️  D1 Database: $D1_REMAINING remaining"
[[ "$R2_REMAINING" -eq 0 ]] && echo "   ✅ R2 Bucket: Clean" || echo "   ⚠️  R2 Bucket: $R2_REMAINING remaining"

echo ""
echo "Verify at: https://dash.cloudflare.com/"
