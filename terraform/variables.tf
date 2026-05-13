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
