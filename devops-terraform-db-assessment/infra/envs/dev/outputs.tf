output "vpc_id" {
  description = "Dev VPC ID"
  value       = module.network.vpc_id
}

output "alb_dns_name" {
  description = "Dev Application Load Balancer DNS"
  value       = module.ecs.alb_dns_name
}

output "ecs_cluster_name" {
  description = "Dev ECS cluster name"
  value       = module.ecs.ecs_cluster_name
}

output "ecs_service_name" {
  description = "Dev ECS service name"
  value       = module.ecs.ecs_service_name
}

output "rds_endpoint" {
  description = "Dev PostgreSQL endpoint"
  value       = module.rds.db_endpoint
}

output "rds_database_name" {
  description = "Dev database name"
  value       = module.rds.db_name
}
