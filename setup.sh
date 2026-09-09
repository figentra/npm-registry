#!/bin/bash
set -e

echo "🚀 Setting up npm-registry with automated resource creation..."
echo ""

# Step 1: Create KV namespace
echo "📦 Creating KV namespace..."
npx wrangler kv namespace create npm-registry --json > /tmp/kv-output.json 2>/dev/null || true
KV_ID=$(npx wrangler kv namespace list 2>/dev/null | grep -A 1 '"title": "npm-registry"' | grep '"id":' | sed 's/.*"id": "\([^"]*\)".*/\1/' | head -1)
echo "   KV ID: $KV_ID"

# Step 2: Create preview KV namespace  
echo "📦 Creating KV preview namespace..."
npx wrangler kv namespace create npm-registry --preview --json > /tmp/kv-preview.json 2>/dev/null || true
KV_PREVIEW_ID=$(npx wrangler kv namespace list 2>/dev/null | grep -A 1 '"title": "npm-registry_preview"' | grep '"id":' | sed 's/.*"id": "\([^"]*\)".*/\1/' | head -1)
echo "   KV Preview ID: $KV_PREVIEW_ID"

# Step 3: Create R2 bucket
echo "📦 Creating R2 bucket..."
npx wrangler r2 bucket create npm-registry-packages 2>/dev/null || echo "   Bucket already exists or created"

# Step 4: Create D1 database
echo "📦 Creating D1 database..."
npx wrangler d1 create npm-registry-db --location eeur 2>/dev/null || true
DB_ID=$(npx wrangler d1 list 2>/dev/null | grep "npm-registry-db" | awk '{print $1}')
echo "   DB ID: $DB_ID"

echo ""
echo "📝 Updating wrangler.toml with resource IDs..."

# Update wrangler.toml
cat > wrangler.toml << EOF
name = "npm-registry"
main = "src/index.ts"
compatibility_date = "2026-01-07"

compatibility_flags = [ "nodejs_compat" ]

[vars]
FALLBACK_REGISTRY_ENDPOINT = "https://registry.npmjs.org"

# Custom Domain
routes = [
  { pattern = "npm.figentra.com", custom_domain = true }
]

# KV Namespace
[[kv_namespaces]]
binding = "NPM_REGISTRY"
id = "$KV_ID"
preview_id = "$KV_PREVIEW_ID"

# R2 Bucket
[[r2_buckets]]
binding = "BUCKET"
bucket_name = "npm-registry-packages"

# D1 Database
[[d1_databases]]
binding = "DB"
database_name = "npm-registry-db"
database_id = "$DB_ID"
EOF

echo ""
echo "🗃️ Applying database migrations..."
npx wrangler d1 migrations apply DB --remote 2>/dev/null || echo "   Migrations may already be applied"

echo ""
echo "🚀 Deploying worker..."
npx wrangler deploy --minify

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Summary:"
echo "   Worker: npm-registry"
echo "   Domain: npm.figentra.com (pending DNS verification)"
echo "   KV: $KV_ID"
echo "   R2: npm-registry-packages"
echo "   D1: npm-registry-db ($DB_ID)"
echo ""
echo "🔗 URLs:"
echo "   https://npm.figentra.com/_/docs"
echo "   https://npm.figentra.com/_/openapi.json"
