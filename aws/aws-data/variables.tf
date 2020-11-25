variable "domain" {
  type        = string
  description = "Route53 domain"
  default     = "codeandtheory.net"
}

variable "private_domain" {
  type        = string
  description = "Non-public Route53 domain"
  default     = "codeandtheory.int"
}

variable "vpc_tags" {
  type        = map(any)
  description = "Tags for looking up VPC"
  default     = {}
}

variable "subnet_tags" {
  type        = map(any)
  description = "Tags for looking up Subnets"
  default     = {}
}

variable "security_group_tags" {
  type        = map(any)
  description = "Tags for looking up SG's"
  default     = {}
}