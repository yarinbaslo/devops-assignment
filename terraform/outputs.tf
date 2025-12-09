output "alb_url" {
  description = "Application Load Balancer URL"
  value       = "http://${module.loadbalancer.alb_dns_name}"
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.loadbalancer.alb_dns_name
}

output "s3_bucket_name" {
  description = "S3 bucket name for emails"
  value       = module.storage.s3_bucket_name
}

output "sqs_queue_url" {
  description = "SQS queue URL"
  value       = module.storage.sqs_queue_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}

output "ecr_repository_1_url" {
  description = "ECR repository 1 URL"
  value       = module.ecs.ecr_repository_1_url
}

output "ecr_repository_2_url" {
  description = "ECR repository 2 URL"
  value       = module.ecs.ecr_repository_2_url
}

output "ecr_repository_1_name" {
  description = "ECR repository 1 name"
  value       = module.ecs.ecr_repository_1_name
}

output "ecr_repository_2_name" {
  description = "ECR repository 2 name"
  value       = module.ecs.ecr_repository_2_name
}

output "ecs_service_1_name" {
  description = "ECS service 1 name"
  value       = module.ecs.ecs_service_1_name
}

output "ecs_service_2_name" {
  description = "ECS service 2 name"
  value       = module.ecs.ecs_service_2_name
}

output "task_family_1_name" {
  description = "Task definition family 1 name"
  value       = module.ecs.task_family_1_name
}

output "task_family_2_name" {
  description = "Task definition family 2 name"
  value       = module.ecs.task_family_2_name
}
