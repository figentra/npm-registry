#!/bin/bash
#==============================================================================
# Cloudflare Resource Cleanup Script (Wrangler-based)
#==============================================================================
# WARNING: This will DELETE ALL npm-registry related resources!
#==============================================================================

set -e

RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m' NC='\033[0m'

echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║  ⚠️  WARNING: DESTRUCTIVE OPERATION                        ║${NC}"
echo -e "${RED}║                                                            ║${NC}"
echo -e "${RED}║  This will DELETE:                                         ║${NC}"
echo -e "${RED}║  • KV Namespaces: npm-registry, npm-registry_preview       ║${NC}"
echo -e "${RED}║  • D1 Database: npm-registry-db                            ║${NC}"
echo -e "${RED}║  • R2 Bucket: npm-registry-packages                      ║${NC}"
echo -e "${RED}║  • Worker Script: npm-registry                             ║${NC}"
echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
read -p "Type 'delete' to continue: " confirm
[[ "$confirm" == "delete" ]] || { echo "Aborted."; exit 1; }

echo ""
echo "🗑️  Deleting resources..."
echo ""

# Delete KV Namespaces
echo "1. Deleting KV Namespaces..."
wrangler kv:namespace delete --namespace-id beef9b9ba42844a8a3a182b1894e7be3 --force 2>/dev/null || echo "   npm-registry: already deleted or error"
wrangler kv:namespace delete --namespace-id 0c7930531f024700affede8e6373eb35 --force 2>/dev/null || echo "   npm-registry_preview: already deleted or error"

# Delete D1 Database
echo "2. Deleting D1 Database..."
wrangler d1 delete npm-registry-db --force 2>/dev/null || echo "   npm-registry-db: already deleted or error"

# Delete R2 Bucket (need to empty first)
echo "3. Deleting R2 Bucket..."
wrangler r2 bucket delete npm-registry-packages --force 2>/dev/null || echo "   npm-registry-packages: already deleted or error"

# Delete Worker Script
echo "4. Deleting Worker Script..."
wrangler delete --name npm-registry --force 2>/dev/null || echo "   npm-registry worker: already deleted or error"

echo ""
echo -e "${GREEN}✓ Cleanup complete!${NC}"
echo ""
echo "Note: Some resources may take a few minutes to fully propagate."
echo "Verify at: https://dash.cloudflare.com/"
