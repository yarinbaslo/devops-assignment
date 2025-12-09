# ECR Repositories
resource "aws_ecr_repository" "ms1" {
  name                 = "ms1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name = "ms1"
  }
}

resource "aws_ecr_repository" "ms2" {
  name                 = "ms2"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name = "ms2"
  }
}

