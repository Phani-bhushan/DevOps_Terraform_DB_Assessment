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
  description = "MySQL database name"
  type        = string
  default     = "bookings"
}

variable "db_username" {
  description = "Master username for MySQL"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Master password for MySQL"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string

  validation {
    condition     = length(trimspace(var.instance_class)) > 0
    error_message = "RDS instance class must not be empty."
  }
}

variable "allocated_storage" {
  description = "Allocated database storage in GB"
  type        = number

  validation {
    condition     = var.allocated_storage >= 20
    error_message = "Allocated storage must be at least 20 GB."
  }
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number

  validation {
    condition = (
      var.backup_retention_period >= 0 &&
      var.backup_retention_period <= 35
    )
    error_message = "Backup retention must be between 0 and 35 days."
  }
}

variable "deletion_protection" {
  description = "Enable RDS deletion protection"
  type        = bool
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting RDS"
  type        = bool

}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}

variable "final_snapshot_identifier" {
  description = "Identifier for the final RDS snapshot"
  type        = string
  default     = null
}
