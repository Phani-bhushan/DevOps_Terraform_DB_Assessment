variable "project_name" {
  description = "Name prefix for RDS resources"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for RDS"
  type        = list(string)
}

variable "rds_security_group_id" {
  description = "Security group ID for RDS"
  type        = string
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "bookings"
}

variable "db_username" {
  description = "Master username for PostgreSQL"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Master password for PostgreSQL"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated database storage in GB"
  type        = number
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
}

variable "deletion_protection" {
  description = "Enable RDS deletion protection"
  type        = bool
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting RDS"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
