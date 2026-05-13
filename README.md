# RouteIQ

RouteIQ is a serverless web platform for overland travel intelligence in South
America.

The MVP is intentionally small and low-cost:

- Flutter Web frontend hosted on S3 and CloudFront
- FastAPI backend running on AWS Lambda through Mangum
- Cognito Hosted UI with username/password login
- DynamoDB allowlist for authorized users
- Temporary HTML reports stored in S3
- Terraform-managed AWS infrastructure

Primary domain: `routeiq.click`

## Development stages

The implementation is split into testable stages in
[docs/implementation-plan.md](docs/implementation-plan.md).

## Local backend

```bash
cd backend
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
PYTHONPATH=. pytest
uvicorn app.main:app --reload
```

## Infrastructure

```bash
terraform -chdir=terraform fmt -recursive
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform validate
```
