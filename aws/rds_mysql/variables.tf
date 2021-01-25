variable "app" {
}

variable "env" {
}

variable "client" {
}

variable "techlead" {
}

variable "db_username" {
  type        = string
  description = "Default username for RDS database"
}

variable "rds_name" {
  type        = string
  description = "DB Name for RDS database"
  default = "db"
}

variable "db_size" {
  type        = string
  description = "Size in gigabytes for RDS database"
  default     = 10
}

variable "db_instance_type" {
  type        = string
  description = "RDS instance class"
  default     = "db.t3.small"
}

variable "deletion_protection" {
  type        = bool
  description = "Use deletion protection for RDS instance"
  default     = false
}

variable "tags" {
  type        = map
  description = "Map of AWS resource tags to add to RDS instance"
  default     = {}
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "db_subnet_group_name" {
}
