output "cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.main.name
}

output "ecr_repository_1_url" {
  description = "ECR repository 1 URL"
  value       = aws_ecr_repository.ms1.repository_url
}

output "ecr_repository_2_url" {
  description = "ECR repository 2 URL"
  value       = aws_ecr_repository.ms2.repository_url
}

output "ecr_repository_1_name" {
  description = "ECR repository 1 name"
  value       = aws_ecr_repository.ms1.name
}

output "ecr_repository_2_name" {
  description = "ECR repository 2 name"
  value       = aws_ecr_repository.ms2.name
}

output "ecs_service_1_name" {
  description = "ECS service 1 name"
  value       = aws_ecs_service.ms1.name
}

output "ecs_service_2_name" {
  description = "ECS service 2 name"
  value       = aws_ecs_service.ms2.name
}

output "task_family_1_name" {
  description = "Task definition family 1 name"
  value       = aws_ecs_task_definition.ms1.family
}

output "task_family_2_name" {
  description = "Task definition family 2 name"
  value       = aws_ecs_task_definition.ms2.family
}

