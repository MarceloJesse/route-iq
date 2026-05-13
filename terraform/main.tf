locals {
  name_prefix = "routeiq-${var.environment}"
}

resource "aws_s3_bucket" "frontend" {
  bucket = "${local.name_prefix}-frontend"
}

resource "aws_s3_bucket" "reports" {
  bucket = "${local.name_prefix}-reports"
}

resource "aws_s3_bucket_lifecycle_configuration" "reports" {
  bucket = aws_s3_bucket.reports.id

  rule {
    id     = "expire-temporary-reports"
    status = "Enabled"

    expiration {
      days = 1
    }
  }
}

resource "aws_dynamodb_table" "authorized_users" {
  name         = "${local.name_prefix}-authorized-users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "email"

  attribute {
    name = "email"
    type = "S"
  }
}
