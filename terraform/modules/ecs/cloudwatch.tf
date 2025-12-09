# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "ms1" {
  name              = "/ecs/ms1"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "ms2" {
  name              = "/ecs/ms2"
  retention_in_days = 7
}

