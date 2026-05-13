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
