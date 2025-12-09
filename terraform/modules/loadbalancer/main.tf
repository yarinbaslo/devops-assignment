# Application Load Balancer
resource "aws_lb" "this" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_groups.alb]
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = {
    Name = "alb"
  }
}

# Target Group for Microservice 1
resource "aws_lb_target_group" "ms1" {
  name        = "ms1-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip" # Required for ECS Fargate with awsvpc network mode

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200-299"
  }

  deregistration_delay = 30

  tags = {
    Name = "ms1-tg"
  }
}

# HTTP Listener
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ms1.arn
  }
}

