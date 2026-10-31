output "vpc_id" {
  description = "Prod VPC ID"
  value       = module.network.vpc_id
}

output "alb_dns_name" {
  description = "Prod Application Load Balancer DNS"
  value       = module.ecs.alb_dns_name
}

output "ecs_cluster_name" {
  description = "Prod ECS cluster name"
  value       = module.ecs.ecs_cluster_name
}

output "ecs_service_name" {
  description = "Prod ECS service name"
  value       = module.ecs.ecs_service_name
}

output "rds_endpoint" {
  description = "Prod MySQL endpoint"
  value       = module.rds.db_endpoint
}

output "rds_database_name" {
  description = "Prod database name"
  value       = module.rds.db_name
}
