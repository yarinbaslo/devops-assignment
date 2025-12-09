terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Networking Module
module "networking" {
  source = "./modules/networking"
}

# Storage Module
module "storage" {
  source = "./modules/storage"

  s3_bucket_name     = var.s3_bucket_name
  sqs_queue_name     = var.sqs_queue_name
  ssm_parameter_name = var.ssm_parameter_name
  ssm_token_value    = var.ssm_token_value
}

module "loadbalancer" {
  source = "./modules/loadbalancer"

  vpc_id          = module.networking.vpc_id
  subnets         = module.networking.subnets
  security_groups = module.networking.security_groups
}

# ECS Module
module "ecs" {
  source = "./modules/ecs"

  vpc_id             = module.networking.vpc_id
  subnets            = module.networking.subnets
  security_groups    = module.networking.security_groups
  alb_target_group   = module.loadbalancer.target_group_arn
  sqs_queue_url      = module.storage.sqs_queue_url
  sqs_queue_arn      = module.storage.sqs_queue_arn
  s3_bucket_name     = module.storage.s3_bucket_name
  s3_bucket_arn      = module.storage.s3_bucket_arn
  ssm_parameter_name = module.storage.ssm_parameter_name
  aws_region         = var.aws_region
}

