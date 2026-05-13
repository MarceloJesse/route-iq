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

output "api_base_url" {
  description = "HTTP API Gateway base URL for the RouteIQ backend."
  value       = aws_apigatewayv2_api.api.api_endpoint
}

output "api_lambda_function_name" {
  description = "Lambda function that serves the FastAPI backend."
  value       = aws_lambda_function.api.function_name
}
