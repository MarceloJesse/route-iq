variable "aws_region" {
  description = "AWS region for RouteIQ production resources."
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Primary RouteIQ domain."
  type        = string
  default     = "routeiq.click"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "prod"
}

variable "google_client_id" {
  description = "Google OAuth client ID for Cognito social login. Leave empty until configured."
  type        = string
  default     = ""
}

variable "google_client_secret" {
  description = "Google OAuth client secret for Cognito social login. Leave empty until configured."
  type        = string
  default     = ""
  sensitive   = true
}

variable "cognito_callback_urls" {
  description = "Allowed callback URLs for Cognito Hosted UI."
  type        = list(string)
  default = [
    "http://localhost:3000/auth/callback",
    "https://routeiq.click/auth/callback",
  ]
}

variable "cognito_logout_urls" {
  description = "Allowed logout URLs for Cognito Hosted UI."
  type        = list(string)
  default = [
    "http://localhost:3000/",
    "https://routeiq.click/",
  ]
}
