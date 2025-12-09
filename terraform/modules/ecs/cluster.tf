# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {
    Name = "cluster"
  }
}

