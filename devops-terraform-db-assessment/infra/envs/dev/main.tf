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
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

module "network" {
  source = "../../modules/network"

  project_name = var.project_name
  vpc_cidr     = "10.10.0.0/16"

  availability_zones = [
    "${var.aws_region}a",
    "${var.aws_region}b"
  ]

  public_subnet_cidrs = [
    "10.10.1.0/24",
    "10.10.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.10.11.0/24",
    "10.10.12.0/24"
  ]

  tags = local.common_tags
}

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
  cpu             = 256
  memory          = 512
  desired_count   = 1

  tags = local.common_tags
}

module "rds" {
  source = "../../modules/rds"

  project_name = var.project_name

  private_subnet_ids    = module.network.private_subnet_ids
  rds_security_group_id = module.network.rds_security_group_id

  db_name     = "bookings"
  db_username = "dbadmin"
  db_password = var.db_password

  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  backup_retention_period = 1
  deletion_protection     = false
  skip_final_snapshot     = true

  tags = local.common_tags
}
