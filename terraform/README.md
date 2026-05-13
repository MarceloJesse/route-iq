# RouteIQ Terraform

This directory manages RouteIQ production infrastructure in `us-east-1`.

## Remote state

Terraform state is stored in:

- bucket: `routeiq-click-tfstate-prod`
- key: `routeiq/prod/terraform.tfstate`

GitHub Actions creates the state bucket idempotently before running
`terraform init`. Local development can still run validation without AWS
credentials:

```bash
terraform init -backend=false
terraform validate
```

## Production apply

Pushes to `main` run:

```bash
terraform init
terraform plan -out=tfplan
terraform apply -auto-approve tfplan
```

The workflow reads AWS credentials from repository secrets:

- `ACCESS_KEY`
- `SECRET_KEY`
