variable "client" {
  description = "Client"
  default     = "kjartan"
}

variable "app" {
  description = "Application"
  default     = "terraform"
}

variable "env" {
  description = "Environment"
  default     = "dev"
}

variable "techlead" {
  description = "Tech Lead"
  default     = "Kjartan Clausen"
}

# Preexsisting
variable "domain" {
  description = "Domain"
  default     = "codeandtheory.io"
}

variable "subdomain" {
  description = "Subdomain"
  default     = "client"
}

# Will be created in the ALB module
#variable "subsubdomain" {
#  description = "Subsubdomain"
#  default     = project
#}

