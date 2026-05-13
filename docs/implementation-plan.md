# RouteIQ implementation plan

RouteIQ will be built in small, testable stages. Each stage should leave the
repository deployable or locally verifiable before the next external dependency
is added.

## Stage 1: Project foundation

Goal: create the repository structure, backend application shell, tests, and CI
checks.

Acceptance checks:

- `GET /health` returns `{ "status": "ok" }`
- `POST /api/routes/analyze` validates the initial request contract
- Backend tests pass locally and in GitHub Actions
- Terraform formatting and validation jobs are defined

## Stage 2: AWS infrastructure baseline

Goal: provision the minimum production AWS resources with Terraform.

Acceptance checks:

- S3 buckets for frontend and temporary reports are managed by Terraform
- DynamoDB authorized users table exists
- API Gateway, Lambda role, and CloudWatch log group are declared
- Outputs expose frontend bucket, reports bucket, and API endpoint

## Stage 3: Authentication

Goal: integrate Cognito Hosted UI with Google login and backend JWT validation.

Acceptance checks:

- Cognito user pool and Google identity provider are provisioned
- Backend validates Cognito JWTs
- Backend checks the authorized users table by email
- Unauthorized users receive `403`

## Stage 4: Route intelligence API

Goal: calculate and normalize route information.

Acceptance checks:

- OpenRouteService integration is covered by provider tests
- Route response includes distance, duration, coordinates, countries, and stops
- External provider failures return typed API errors

## Stage 5: News and AI summary

Goal: enrich route context with news and Bedrock-generated travel intelligence.

Acceptance checks:

- News aggregation has deterministic tests with mocked providers
- Bedrock prompt and response parsing are tested
- Analyze response includes summary, alerts, and news items

## Stage 6: Reports

Goal: generate temporary HTML reports and signed URLs.

Acceptance checks:

- HTML report rendering is tested with sample route intelligence
- Reports are uploaded to S3 with one-day lifecycle
- Signed report URL is returned by the API

## Stage 7: Flutter web frontend

Goal: build the authenticated web experience.

Acceptance checks:

- Login redirects to Cognito Hosted UI
- Dashboard submits route requests
- Report view renders map, alerts, news, and download action
- Flutter analyze and web build pass in CI

## Stage 8: Production domain and deployment

Goal: publish RouteIQ at `routeiq.click`.

Acceptance checks:

- ACM certificate is issued in `us-east-1`
- CloudFront serves the frontend
- Route53 records point `routeiq.click` to CloudFront
- Main branch deploys through GitHub Actions using AWS secrets
