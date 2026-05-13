# RouteIQ - Architecture and Implementation Guide

## Overview

RouteIQ is a serverless web platform focused on overland travel intelligence for South America.

The platform allows authenticated users to:

- Create road trip routes
- Define origin and destination
- Add optional route stops (waypoints)
- Analyze travel routes using map providers
- Retrieve route-related news and alerts
- Generate AI-powered travel intelligence reports
- Share temporary public reports
- Download generated reports

The platform is intentionally designed as a low-cost MVP using AWS serverless technologies.

Primary domain:

`routeiq.click`

---

# Product Goals

## MVP Goals

The MVP should:

- Be simple and inexpensive to operate
- Require minimal infrastructure management
- Be fully deployed using Terraform
- Support only Portuguese initially
- Support only Google social login
- Focus on South American routes
- Avoid permanent report persistence
- Generate temporary reports stored in S3
- Provide a responsive web experience

---

# High-Level Architecture

## Frontend

Technology:

- Flutter Web

Responsibilities:

- Authentication
- Route form UI
- Interactive map rendering
- Report visualization
- Public report visualization
- HTML report download

Hosting:

- AWS S3
- AWS CloudFront

---

## Backend

Technology:

- Python 3.12
- FastAPI
- Mangum
- AWS Lambda
- API Gateway

Responsibilities:

- JWT validation
- Authorized email validation
- Route calculation
- News aggregation
- Optional scraping fallback
- Bedrock summarization
- Report generation
- Temporary S3 upload
- Signed URL generation

---

## Authentication

Technology:

- AWS Cognito
- Google Social Login

Authentication flow:

1. User accesses frontend
2. Cognito Hosted UI handles login
3. Google OAuth authentication
4. Cognito returns JWT token
5. Frontend stores token securely
6. Backend validates JWT
7. Backend validates user email allowlist

---

## Infrastructure

Technology:

- Terraform
- GitHub Actions

AWS Services:

- API Gateway
- Lambda
- Cognito
- DynamoDB
- S3
- CloudFront
- Bedrock
- IAM
- CloudWatch

---

# AWS Architecture

## Components

### Frontend Layer

- S3 static website bucket
- CloudFront distribution
- Route53 hosted zone
- ACM certificate

### Authentication Layer

- Cognito User Pool
- Cognito Identity Provider (Google)
- Cognito Hosted UI

### API Layer

- API Gateway HTTP API
- JWT authorizer

### Compute Layer

- Single FastAPI Lambda function
- Mangum adapter

### Data Layer

- DynamoDB table for authorized users
- S3 temporary reports bucket

### AI Layer

- Amazon Bedrock

### Observability

- CloudWatch Logs
- CloudWatch Metrics

---

# Suggested AWS Region

Recommended region:

`us-east-1`

Reasons:

- Better Bedrock support
- Lower latency for South America
- Simplified ACM + CloudFront setup
- Better service availability

---

# Route Processing Flow

## Sequence

1. User authenticates
2. User submits route request
3. Frontend calls backend API
4. Backend validates JWT
5. Backend validates allowlisted email
6. Backend calls OpenRouteService
7. Backend extracts:
   - countries
   - borders
   - cities
   - waypoints
8. Backend searches news APIs
9. Backend optionally executes fallback scraping
10. Backend builds structured travel context
11. Backend sends prompt to Bedrock
12. Bedrock generates structured summary
13. Backend generates HTML report
14. HTML report uploaded to S3
15. Backend generates signed URL
16. Backend returns:
   - route metadata
   - map coordinates
   - summarized insights
   - alerts
   - report URL

---

# Route Provider

## Initial Provider

Primary provider:

- OpenStreetMap
- OpenRouteService

Reasons:

- Free tier
- Low operational cost
- Good South America coverage
- Simple API integration

Future migration options:

- Mapbox
- Google Maps

---

# News Aggregation Strategy

## Initial Strategy

Use public news APIs whenever possible.

Potential providers:

- NewsAPI
- GDELT
- Google News RSS

---

## Fallback Scraping

If no sufficient results are found:

- Use lightweight scraping
- Only predefined trusted sources
- Country-specific news portals

Example sources:

- Chile
- Argentina
- Bolivia
- Peru
- Brazil

---

# AI Processing

## Bedrock Usage

Purpose:

- Summarize travel risks
- Summarize route quality
- Extract important alerts
- Produce concise travel intelligence

Output style:

- Objective
- Short paragraphs
- Travel-focused
- Operational tone

---

## Example Report Sections

### Route Summary

- Total distance
- Estimated duration
- Countries crossed
- Border crossings

### Road Quality

- Asphalt conditions
- Dirt roads
- Mountain roads
- Weather risks

### Travel Alerts

- Protests
- Road blocks
- Flooding
- Construction
- Border delays

### News Summary

- Relevant summarized articles
- Publication date
- Source name

---

# Frontend Architecture

## Flutter Structure

Suggested structure:

```text
frontend/
├── lib/
│   ├── core/
│   ├── services/
│   ├── models/
│   ├── pages/
│   ├── widgets/
│   ├── auth/
│   ├── routing/
│   └── main.dart
├── assets/
├── pubspec.yaml
└── web/
```

---

## Frontend Pages

### Login Page

Features:

- Minimal design
- Google login button
- Cognito Hosted UI redirect

---

### Dashboard Page

Features:

- Origin input
- Destination input
- Add stop button
- Date selector
- Analyze route button

---

### Report Page

Features:

- Interactive map
- Route visualization
- AI summary
- Alert cards
- News cards
- Download report button
- Public share link

---

# Backend Architecture

## Suggested Structure

```text
backend/
├── app/
│   ├── api/
│   ├── auth/
│   ├── services/
│   ├── providers/
│   ├── models/
│   ├── prompts/
│   ├── utils/
│   └── main.py
├── tests/
├── requirements.txt
└── Dockerfile
```

---

# FastAPI Endpoints

## Health Endpoint

```http
GET /health
```

Response:

```json
{
  "status": "ok"
}
```

---

## Analyze Route

```http
POST /api/routes/analyze
```

Request:

```json
{
  "origin": "Santiago, Chile",
  "destination": "Uyuni, Bolivia",
  "stops": [
    "San Pedro de Atacama"
  ],
  "travel_date": "2026-01-15"
}
```

Response:

```json
{
  "route": {},
  "summary": {},
  "alerts": [],
  "news": [],
  "report_url": "https://signed-url"
}
```

---

## Public Report Endpoint

```http
GET /public/reports/{report_id}
```

---

# DynamoDB Design

## Table: authorized_users

Partition key:

```text
email
```

Example item:

```json
{
  "email": "user@example.com",
  "enabled": true
}
```

---

# S3 Design

## Frontend Bucket

Purpose:

- Flutter web hosting

Example:

```text
routeiq-frontend-prod
```

---

## Reports Bucket

Purpose:

- Temporary HTML reports

Example:

```text
routeiq-reports-prod
```

Lifecycle:

- Auto-delete after 1 day

---

# Terraform Structure

## Suggested Structure

```text
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars
├── modules/
│   ├── api/
│   ├── lambda/
│   ├── cognito/
│   ├── s3/
│   ├── dynamodb/
│   └── cloudfront/
└── environments/
    └── prod/
```

---

# Terraform Responsibilities

Terraform should provision:

- Cognito resources
- Google identity provider
- API Gateway
- Lambda
- IAM policies
- DynamoDB table
- S3 buckets
- CloudFront
- Route53 records
- ACM certificates
- CloudWatch logs

---

# GitHub Repository Structure

```text
routeiq/
├── frontend/
├── backend/
├── terraform/
├── .github/
│   └── workflows/
├── docs/
├── README.md
└── ARCHITECTURE.md
```

---

# GitHub Actions CI/CD

## Pull Request Workflow

Trigger:

- Pull requests

Actions:

1. Terraform fmt
2. Terraform validate
3. Terraform plan
4. Backend lint
5. Backend tests
6. Flutter analyze
7. Flutter build validation

---

## Main Branch Workflow

Trigger:

- Merge to main

Actions:

1. Terraform apply
2. Backend deployment
3. Frontend build
4. Frontend upload to S3
5. CloudFront invalidation

---

# GitHub Actions Example

## PR Workflow

File:

```text
.github/workflows/pr.yml
```

---

## Deploy Workflow

File:

```text
.github/workflows/deploy.yml
```

---

# Security Model

## Authentication

- Cognito Hosted UI
- Google OAuth only

---

## Authorization

- Allowlisted emails only
- DynamoDB validation

---

## API Security

- JWT validation
- HTTPS only
- Signed S3 URLs

---

## IAM Principle

Use least privilege access.

Lambda permissions should only include:

- Read/write reports bucket
- Read authorized users table
- Invoke Bedrock
- Write logs

---

# Logging

## CloudWatch Logs

Log:

- Route requests
- External API failures
- Bedrock errors
- Authentication failures

Avoid logging:

- JWT tokens
- Sensitive user data

---

# Monitoring

## Initial Monitoring

Use:

- CloudWatch Metrics
- CloudWatch Logs

Monitor:

- Lambda duration
- Lambda errors
- API Gateway 5xx
- Bedrock latency

---

# Minimal UI Design Guidelines

## Design Philosophy

The UI should be:

- Minimal
- Fast
- Clean
- Responsive
- Mobile-friendly

---

## Colors

Suggested palette:

- White background
- Light gray cards
- Dark text
- Blue action buttons

---

## Components

Prefer:

- Simple cards
- Rounded corners
- Large spacing
- Minimal animations

Avoid:

- Complex dashboards
- Heavy gradients
- Overengineered interactions

---

# Suggested Bedrock Prompt Strategy

## Prompt Inputs

Provide:

- Route information
- Countries crossed
- Border crossings
- News articles
- Road quality information
- Travel date

---

## Expected Output

Generate:

- Route overview
- Important warnings
- Road quality assessment
- Border crossing notes
- Travel recommendations

Tone:

- Professional
- Objective
- Concise

---

# Future Improvements

## Phase 2 Ideas

- PDF generation
- Persistent trip history
- User dashboard
- Route caching
- Real-time alerts
- Push notifications
- WhatsApp integration
- Multi-language support
- Mobile app
- Offline support
- AI route scoring
- Dangerous area detection

---

# Development Standards

## Backend

Requirements:

- Type hints
- Pydantic validation
- Structured logging
- Modular services
- Unit tests

---

## Frontend

Requirements:

- Responsive design
- State management
- API abstraction layer
- Reusable widgets

---

## Terraform

Requirements:

- Modular structure
- Reusable modules
- Clear variable naming
- Remote state support later

---

# Initial MVP Deliverables

## Infrastructure

- Terraform deployment
- Cognito setup
- Lambda deployment
- API Gateway deployment
- CloudFront deployment

---

## Frontend

- Login page
- Route form page
- Report page

---

## Backend

- Route endpoint
- OpenRouteService integration
- News aggregation
- Bedrock summarization
- HTML report generation

---

# Recommended Development Order

## Phase 1

- Terraform foundation
- Cognito setup
- Frontend hosting
- API Gateway
- Lambda deployment

---

## Phase 2

- Authentication flow
- JWT validation
- Allowlist validation

---

## Phase 3

- Route provider integration
- Frontend route form
- Map rendering

---

## Phase 4

- News aggregation
- Bedrock integration
- HTML report generation

---

## Phase 5

- GitHub Actions CI/CD
- Observability
- Security hardening

---

# Final Notes

This architecture intentionally prioritizes:

- Low operational cost
- Fast MVP delivery
- Minimal complexity
- Easy maintainability
- Serverless scalability

The architecture is designed to evolve incrementally without requiring major rewrites.
