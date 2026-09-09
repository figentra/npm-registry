# NPM Registry Infrastructure

Production-grade Terraform for the private npm registry on Cloudflare.

## Why the previous deployment failed

Terraform successfully created the KV namespace, D1 database, and R2 bucket.
The failure happened later during `npx wrangler deploy`. Wrangler attempted to
bind `env.NPM_REGISTRY` to a KV namespace ID that was not the namespace Terraform
had created. The Terraform state shows the production KV namespace as
`48285cc2cdbf40aaa941355d2b3595b9`, while the Worker upload referenced a
 different ID. Cloudflare therefore rejected the Worker upload with error
`10041: KV namespace ... not found`.

The old design also made Terraform depend on a `null_resource` and
`local-exec` deployment. That meant Terraform state and Wrangler configuration
could disagree. The refactored design removes that second source of truth:
Terraform directly manages the Worker bindings and references the actual
Terraform resources.

Cloudflare's current Terraform provider supports `cloudflare_workers_script`
with `content_file`, `content_sha256`, and first-class bindings. This is the
preferred pattern here because the Worker artifact is deployed by Terraform
while its KV/D1/R2 binding IDs come directly from Terraform resources.

## Structure

```text
terraform/
├── main.tf                         # Production composition only
├── versions.tf                     # Terraform/provider version policy
├── providers.tf                    # Provider authentication
├── variables.tf                    # Production inputs
├── outputs.tf                      # Production outputs
├── terraform.tfvars.example        # Safe configuration template
├── modules/
│   └── npm-registry/
│       ├── main.tf                 # Module locals and shared conventions
│       ├── variables.tf             # Module contract
│       ├── cache.tf                 # KV namespaces
│       ├── database.tf              # D1 database
│       ├── storage.tf               # R2 bucket
│       ├── worker.tf                # Worker + bindings
│       ├── domain.tf                # Custom domain
│       └── outputs.tf               # Module outputs
├── environments/
│   └── production/
│       └── README.md
└── scripts/
    ├── deploy.sh                    # Build + validate + plan + apply
    └── import-existing.sh           # Existing-resource adoption helper
```

## Important design rules

1. **Terraform owns infrastructure and Worker bindings.** Do not manually copy
   KV/D1/R2 IDs into Wrangler configuration.
2. **The application build owns compilation.** Build the Worker first and give
   Terraform the immutable JavaScript artifact.
3. **State must be remote for a team.** Use an appropriate Terraform backend
   before multiple engineers or CI jobs manage production.
4. **Secrets never belong in Git.** Use environment variables or a secret
   manager for `TF_VAR_cloudflare_api_token`.
5. **Do not run `terraform apply -auto-approve` directly in CI.** Generate a
   plan, review it, then apply the exact plan artifact.
6. **Do not keep a committed `terraform.tfstate`.** The previous archive
   contained state; remove it from source control and migrate the state to a
   remote backend.

## First-time setup

```bash
cp terraform.tfvars.example terraform.tfvars
# Fill in the three Cloudflare values.
```

For local development you can export the token instead:

```bash
export TF_VAR_cloudflare_api_token='...'
export TF_VAR_cloudflare_account_id='...'
export TF_VAR_cloudflare_zone_id='...'
```

Then:

```bash
./scripts/deploy.sh
```

The script expects the application build to create:

```text
dist/worker.js
```

If your existing build emits a different file, change
`worker_content_file` in `terraform.tfvars`. Do not hard-code Cloudflare
resource IDs in the Worker configuration.

## Existing resources

The supplied state already contains these resources:

- D1: `npm-registry-db`
- R2: `npm-registry-packages`
- KV production: `npm-registry`
- KV preview: `npm-registry-preview`

Use `scripts/import-existing.sh` only when rebuilding state from scratch. Do
not import resources into a state that already manages them.

## State migration

The original archive included a local `terraform.tfstate`. That file contains
Cloudflare resource identifiers and should not be treated as application
source. Before production team usage, migrate state to your approved remote
Terraform backend and remove the local state from the repository.

## Verification

Run:

```bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan
```

A healthy plan should not attempt to recreate the existing KV, D1, or R2
resources merely because the Worker binding IDs changed. The Worker binding
IDs are now derived directly from Terraform resource references.
