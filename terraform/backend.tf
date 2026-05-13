terraform {
  backend "s3" {
    bucket       = "routeiq-click-tfstate-prod"
    key          = "routeiq/prod/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
