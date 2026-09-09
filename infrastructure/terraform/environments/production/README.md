# Production environment

The root Terraform configuration currently represents the production
registry. The reusable implementation is in `../../modules/npm-registry`.

If additional environments are introduced later, create another environment
folder with its own variables/state boundary rather than adding conditionals
throughout the module.
