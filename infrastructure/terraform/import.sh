#!/bin/bash
set -e

ACCOUNT_ID="d861f9ac9df28b7f0b1298cc0c89bc9d"

# Import KV Namespaces
echo "Importing KV namespaces..."
terraform import module.npm_registry.cloudflare_workers_kv_namespace.npm_registry "$ACCOUNT_ID/23f1f62591bb4021bb8d9e5e83f40782" || echo "Already imported or error"
terraform import module.npm_registry.cloudflare_workers_kv_namespace.npm_registry_preview "$ACCOUNT_ID/d0bcc4a259c3451a813b531021dd5af6" || echo "Already imported or error"

# Import D1 Database
echo "Importing D1 database..."
terraform import module.npm_registry.cloudflare_d1_database.npm_registry "$ACCOUNT_ID/97307571-f06d-4f19-b959-d7c09deac600" || echo "Already imported or error"

# Import R2 Bucket
echo "Importing R2 bucket..."
terraform import module.npm_registry.cloudflare_r2_bucket.npm_packages "$ACCOUNT_ID/npm-registry-packages" || echo "Already imported or error"

echo "Import complete!"
