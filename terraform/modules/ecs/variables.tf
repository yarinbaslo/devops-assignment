variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnets" {
  description = "Subnet IDs for ECS tasks"
  type        = list(string)
}

variable "security_groups" {
  description = "Security groups map"
  type = object({
    alb = string
    ecs = string
  })
}

variable "alb_target_group" {
  description = "ALB target group ARN"
  type        = string
}

variable "sqs_queue_url" {
  description = "SQS queue URL"
  type        = string
}

variable "sqs_queue_arn" {
  description = "SQS queue ARN"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ssm_parameter_name" {
  description = "SSM Parameter name for token"
  type        = string
}
