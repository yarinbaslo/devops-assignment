output "alb_dns_name" {
  description = "Alb DNS name"
  value       = aws_lb.this.dns_name
}

output "alb_arn" {
  description = "Alb ARN"
  value       = aws_lb.this.arn
}

output "target_group_arn" {
  description = "Target group ARN for Microservice 1"
  value       = aws_lb_target_group.ms1.arn
}

