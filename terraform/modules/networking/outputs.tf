output "vpc_id" {
  description = "VPC ID"
  value       = data.aws_vpc.default.id
}

output "subnets" {
  description = "Subnet IDs"
  value       = data.aws_subnets.default.ids
}

output "security_groups" {
  description = "Security groups map"
  value = {
    alb = aws_security_group.alb_sg.id
    ecs = aws_security_group.ecs_sg.id
  }
}

