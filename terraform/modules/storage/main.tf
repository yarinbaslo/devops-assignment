# S3 bucket for storing processed email data
resource "aws_s3_bucket" "emails_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name    = var.s3_bucket_name
  }
}

# Lifecycle rules — only expiration (delete old files)
resource "aws_s3_bucket_lifecycle_configuration" "emails_lifecycle" {
  bucket = aws_s3_bucket.emails_bucket.id

  rule {
    id     = "delete-old-files"
    status = "Enabled"

    filter {}

    expiration {
      days = 90
    }
  }
}

# SQS queue for incoming email events
resource "aws_sqs_queue" "emails_queue" {
  name                      = var.sqs_queue_name
  message_retention_seconds = 86400
  receive_wait_time_seconds = 0    
  visibility_timeout_seconds = 30 
    
  tags = {
    Name    = var.sqs_queue_name
  }
}

# SSM Parameter for authentication token
resource "aws_ssm_parameter" "token" {
  name        = var.ssm_parameter_name
  description = "Authentication token for microservice 1"
  type        = "SecureString"
  value       = var.ssm_token_value

  tags = {
    Name = "${var.ssm_parameter_name}-token"
  }
}
