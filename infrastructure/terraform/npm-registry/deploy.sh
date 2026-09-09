#!/bin/bash
set -e

echo "🚀 Building and deploying npm-registry with Terraform..."
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(dirname "$0")"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

cd "$SCRIPT_DIR"

# Check if terraform.tfvars exists
if [ ! -f "terraform.tfvars" ]; then
    echo "❌ Error: terraform.tfvars not found!"
    echo "   Copy terraform.tfvars.example to terraform.tfvars and fill in your values."
    exit 1
fi

echo "📦 Step 1: Building worker..."
cd "$PROJECT_ROOT"
if [ ! -d "dist" ]; then
    npx wrangler deploy --dry-run --outdir=dist 2>/dev/null || npm run build
fi

echo ""
echo "🔧 Step 2: Initializing Terraform..."
cd "$SCRIPT_DIR"
terraform init

echo ""
echo "📋 Step 3: Planning changes..."
terraform plan -out=tfplan

echo ""
echo "🚀 Step 4: Applying changes..."
terraform apply tfplan

echo ""
echo "🚀 Step 5: Deploying Worker..."
cd "$PROJECT_ROOT"
npx wrangler deploy --minify

echo ""
echo "✅ Deployment complete!"
echo ""
cd "$SCRIPT_DIR"
terraform output
