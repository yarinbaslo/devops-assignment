output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.emails_bucket.bucket
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.emails_bucket.arn
}

output "sqs_queue_url" {
  description = "SQS queue URL"
  value       = aws_sqs_queue.emails_queue.url
}

output "sqs_queue_arn" {
  description = "SQS queue ARN"
  value       = aws_sqs_queue.emails_queue.arn
}

output "ssm_parameter_name" {
  description = "SSM Parameter name for token"
  value       = aws_ssm_parameter.token.name
}

