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
  default     = codeandtheory.net
}

# Will always be created
variable "subdomain" {
  description = "Subdomain (client or project)"
  default     = client
}

# optional
# list of domains
variable "subsubdomain" {
  description = "Subsubdomain (project or environment)"
  default     = project
}

# optional
# list of domains
# list of domains
variable "subsubsubdomain" {
  description = "Subsubsubdomain (environment or type of service)"
  default     = environment
}

