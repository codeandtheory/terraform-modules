variable "app" {
}

variable "env" {
}

variable "client" {
}
  
variable "techlead" {
  description = "Tech Lead"
  default     = "John Doe"
}

variable "node_type" {
  type        = string
  default     = "cache.t2.micro"
  description = "Elasticache instance type"
}

variable "num_cache_nodes" {
  type        = number
  default     = 1
  description = "Number of nodes in cluster"
}

variable "port" {
  type        = number
  default     = 6379
  description = "Redis port"
}

variable "engine" {
  type        = string
  default     = "redis"
  description = "Redis, of course"
}

# Make sure engine_version and cachefamily are in sync!
variable "engine_version" {
  type        = string
  default     = "4.0.10"
  description = "Redis engine version"
}

variable "cachefamily" {
  type        = string
  default     = "redis4.0"
  description = "Redis family"
}

variable "maintenance_window" {
  type        = string
  default     = "wed:03:00-wed:04:00"
  description = "Maintenance window"
}

variable "cache_security_group_ids" {
  default     = ""
}

variable "snapshot_window" {
  type        = string
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster."
  default     = "06:30-07:30"
}

variable "snapshot_retention_limit" {
  type        = number
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them."
  default     = 0
}
