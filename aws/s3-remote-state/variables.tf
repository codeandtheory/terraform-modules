variable "profile" {
  description = "Which AWS account are we placing the bucket in?"
  default     = "default"
}

variable "region" {
  description = "What region are we placing the bucket in?"
  default     = "us-east-2"
}

variable "client" {
  description = "Client name"
  default     = "kjartan"
}
  
variable "techlead" {
  description = "Tech Lead"
  default     = "John Doe"
}

variable "app" {
  description = "Application"
  default     = "kc-kops-test"
}

variable "env" {
  description = "Environment"
  default     = "dev"
}
