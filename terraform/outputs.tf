output "frontend_bucket_name" {
  description = "S3 bucket that will host the Flutter web build."
  value       = aws_s3_bucket.frontend.bucket
}

output "reports_bucket_name" {
  description = "S3 bucket for temporary generated HTML reports."
  value       = aws_s3_bucket.reports.bucket
}

output "authorized_users_table_name" {
  description = "DynamoDB table for allowlisted users."
  value       = aws_dynamodb_table.authorized_users.name
}
