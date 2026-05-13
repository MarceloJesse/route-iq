# Production environment

Production uses the root Terraform module with:

- region: `us-east-1`
- domain: `routeiq.click`
- environment: `prod`

The GitHub Actions AWS credentials should be stored as repository secrets:

- `ACCESS_KEY`
- `SECRET_KEY`
