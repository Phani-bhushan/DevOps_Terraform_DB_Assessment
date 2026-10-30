variable "project_name" {
  description = "Name prefix for assessment resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones for public and private subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "allowed_http_cidr" {
  description = "CIDR allowed to access the ALB over HTTP"
  type        = string
  default     = "0.0.0.0/0"
}

variable "database_port" {
  description = "PostgreSQL database port"
  type        = number
  default     = 5432
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
