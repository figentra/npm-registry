# NPM Registry - Terraform Deployment

Infrastructure as Code for the private npm registry.

## Quick Start

```bash
# 1. Set up credentials
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# 2. Deploy
./deploy.sh

# Or manually:
terraform init
terraform plan
terraform apply
```

## Structure

```
terraform/
├── main.tf              # Root module configuration  
├── variables.tf         # Input variables
├── modules/
│   └── npm-registry/    # Reusable module
│       ├── main.tf
│       ├── variables.tf
│       ├── data/        # KV, R2, D1 resources
│       └── networking/  # DNS and domains
└── npm-registry/        # Production deployment
    └── terraform.tfvars
```

## Resources Created

| Resource | Type | Purpose |
|----------|------|---------|
| npm-registry | KV Namespace | Package metadata cache |
| npm-registry-preview | KV Namespace | Development/testing |
| npm-registry-packages | R2 Bucket | Package tarballs |
| npm-registry-db | D1 Database | Tokens & auth |
| npm.figentra.com | Worker Domain | Custom domain |

## Requirements

- Terraform >= 1.7.0
- Cloudflare API Token with:
  - Account:Read, Account:Edit
  - Zone:Read, Zone:Edit
  - Workers Scripts:Edit
  - KV:Edit, D1:Edit, R2:Edit

## Secrets

Create `terraform.tfvars`:

```hcl
cloudflare_api_token  = "your-token"
cloudflare_account_id = "d861f9ac9df28b7f0b1298cc0c89bc9d"
cloudflare_zone_id    = "your-zone-id"
```
