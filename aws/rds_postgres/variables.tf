variable "settings" {
  type        = map
  description = "Map of settings to use for Postgres"
  default     = {}
}
variable "security_group_ids" {
  type        = list
  description = "List of AWS security groups to allow access to this RDS instance"
  default     = []
}

variable "subnet_ids" {
  type        = list
  description = "List of security group ID's"
  default     = []
}

variable "route53_zone_id" {
  type        = string
  description = "Route53 Zone ID for DNS record"
}

variable "db_host" {
  type        = string
  description = "Route53 CNAME for RDS instance"
}

variable "db_username" {
  type        = string
  description = "Default username for RDS database"
  default     = "datacloud"
}

variable "db_name" {
  type        = string
  description = "DB Name for RDS database"
  default     = "datacloud"
}

variable "db_size" {
  type        = string
  description = "Size in gigabytes for RDS database"
  default     = 10
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t2.small"
}

variable "db_identifier" {
  type        = string
  description = "RDS instance class"
}

variable "db_parameters" {
  type        = list
  description = "RDS instance class"
  default     = []
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

variable "encrypted" {
  type        = bool
  description = "Is RDS encrypted"
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "AWS VPC ID"
}

variable "engine_version" {
  type        = string
  description = "Engine version"
  default     = "11.8"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Auto upgrade minor version"
  default     = false
}