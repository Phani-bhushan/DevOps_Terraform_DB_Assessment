terraform {
  required_version = ">= 1.5.0"

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

locals {
  common_tags = {
    Project     = var.project_name
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

# Network Module
module "network" {
  source = "../../modules/network"

  project_name = var.project_name
  vpc_cidr     = "10.20.0.0/16"

  availability_zones = [
    "${var.aws_region}a",
    "${var.aws_region}b"
  ]

  public_subnet_cidrs = [
    "10.20.1.0/24",
    "10.20.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.20.11.0/24",
    "10.20.12.0/24"
  ]

  tags = local.common_tags
}

# ECS Module
module "ecs" {
  source = "../../modules/ecs"

  project_name = var.project_name

  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  private_subnet_ids    = module.network.private_subnet_ids
  alb_security_group_id = module.network.alb_security_group_id
  ecs_security_group_id = module.network.ecs_security_group_id

  container_image = "nginx:latest"
  container_port  = 80
  cpu             = 512
  memory          = 1024
  desired_count   = 2

  tags = local.common_tags
}

# RDS Module
module "rds" {
  source = "../../modules/rds"

  project_name = var.project_name

  private_subnet_ids    = module.network.private_subnet_ids
  rds_security_group_id = module.network.rds_security_group_id

  db_name     = "bookings"
  db_username = "dbadmin"
  db_password = var.db_password

  instance_class          = "db.t3.small"
  allocated_storage       = 50
  backup_retention_period = 7
  deletion_protection     = true
  skip_final_snapshot     = false

  tags = local.common_tags
}
