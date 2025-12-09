# Task Definition for Microservice 1
resource "aws_ecs_task_definition" "ms1" {
  family                   = "ms1"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256" # 0.25 vCPU - cost optimization
  memory                   = "512" # 0.5 GB - cost optimization
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([{
    name  = "ms1"
    image = "${aws_ecr_repository.ms1.repository_url}:latest"
    portMappings = [{
      containerPort = 8080
      protocol      = "tcp"
    }]
    environment = [
      {
        name  = "SQS_QUEUE_URL"
        value = var.sqs_queue_url
      },
      {
        name  = "SSM_PARAMETER_NAME"
        value = var.ssm_parameter_name
      },
      {
        name  = "AWS_REGION"
        value = var.aws_region
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.ms1.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])

  tags = {
    Name = "ms1"
  }
}

# Task Definition for Microservice 2
resource "aws_ecs_task_definition" "ms2" {
  family                   = "ms2"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([{
    name  = "ms2"
    image = "${aws_ecr_repository.ms2.repository_url}:latest"
    environment = [
      {
        name  = "SQS_QUEUE_URL"
        value = var.sqs_queue_url
      },
      {
        name  = "S3_BUCKET_NAME"
        value = var.s3_bucket_name
      },
      {
        name  = "AWS_REGION"
        value = var.aws_region
      },
      {
        name  = "POLL_INTERVAL"
        value = "1"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.ms2.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])

  tags = {
    Name = "ms2"
  }
}

