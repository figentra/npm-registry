# Infrastructure as Code - npm-registry

Terraform configuration for deploying the npm-registry Cloudflare Worker with all required resources.

## Resources Created

- **Cloudflare Worker**: `npm-registry`
- **KV Namespaces**: `npm-registry` (prod) + `npm-registry_preview`
- **R2 Bucket**: `npm-registry-packages` (for tarball storage)
- **D1 Database**: `npm-registry-db` (for metadata and tokens)
- **Custom Domain**: `npm.figentra.com`

## Prerequisites

1. [Terraform](https://www.terraform.io/downloads) >= 1.7.0
2. [Cloudflare API Token](https://dash.cloudflare.com/profile/api-tokens) with:
   - Zone:Read, Zone:Edit
   - Account:Read, Workers Scripts:Edit
   - D1:Edit, R2:Edit, KV:Edit

## Setup

1. Copy the example vars file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your values:
   ```hcl
   cloudflare_api_token  = "your-token"
   cloudflare_account_id = "d861f9ac9df28b7f0b1298cc0c89bc9d"
   zone_id               = "your-zone-id"
   domain                = "npm.figentra.com"
   ```

3. Deploy:
   ```bash
   ./deploy.sh
   ```

   Or manually:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## GitHub Actions CI/CD

Set these secrets in your GitHub repository:

| Secret | Description |
|--------|-------------|
| `CLOUDFLARE_API_TOKEN` | API token with edit permissions |
| `CLOUDFLARE_ACCOUNT_ID` | Your Cloudflare account ID |
| `CLOUDFLARE_ZONE_ID` | Zone ID for figentra.com |

## Outputs

| Output | Description |
|--------|-------------|
| `worker_url` | The deployed worker URL |
| `kv_namespace_id` | KV namespace ID |
| `d1_database_id` | D1 database ID |
| `r2_bucket_name` | R2 bucket name |

## Destroy

⚠️ **Warning**: This will delete all data!

```bash
terraform destroy
```
