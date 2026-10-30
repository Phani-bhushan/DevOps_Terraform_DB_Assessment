variable "project_name" {
  description = "Name prefix for ECS resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ECS and ALB will run"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID for ALB"
  type        = string
}

variable "ecs_security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "container_image" {
  description = "Docker image used by the ECS application"
  type        = string
  default     = "nginx:latest"
}

variable "container_port" {
  description = "Application container port"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "Fargate task CPU units"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Fargate task memory in MiB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
