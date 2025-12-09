variable "s3_bucket_name" {
  description = "Name for the S3 bucket"
  type        = string
}

variable "sqs_queue_name" {
  description = "Name for the SQS queue"
  type        = string
}

variable "ssm_parameter_name" {
  description = "Name for the SSM Parameter Store token"
  type        = string
}

variable "ssm_token_value" {
  description = "Value for the SSM Parameter Store token"
  type        = string
  sensitive   = true
}

