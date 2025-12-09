# ECS Service for Microservice 1
resource "aws_ecs_service" "ms1" {
  name            = "ms1"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.ms1.arn
  desired_count   = 1 # Cost optimization - single instance
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_groups.ecs]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.alb_target_group
    container_name   = "ms1"
    container_port   = 8080
  }

  depends_on = [aws_iam_role_policy.ecs_task]

  tags = {
    Name = "ms1"
  }
}

# ECS Service for Microservice 2
resource "aws_ecs_service" "ms2" {
  name            = "ms2"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.ms2.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_groups.ecs]
    assign_public_ip = true
  }

  depends_on = [aws_iam_role_policy.ecs_task]

  tags = {
    Name = "ms2"
  }
}

