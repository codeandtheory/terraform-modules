variable "name" {
  type        = string
  description = "Name of Helm release"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace"
}

variable "route53_zone_id" {
  type        = string
  description = "Route53 Zone ID"
  default     = ""
}

variable "load_balancer" {
  type        = string
  description = "Load balancer to CNAME records to"
  default     = ""
}

variable "values_overrides" {
  type        = map(any)
  description = "Helm overrides"
  default     = {}
}

variable "chart" {
  type        = string
  description = "Path to Helm chart"
}

variable "chart_repository_name" {
  type        = string
  description = "Name of chart repo to add"
  default     = "codeandtheory"
}

variable "chart_repository_url" {
  type        = string
  description = "URL for Helm chart repository"
  default     = "https://charts.codeandtheory.net"
}

variable "timeout" {
  type        = number
  description = "Helm timeout"
  default     = 900
}

variable "values_files" {
  type        = list
  description = "List of values files"
  default     = []
}

variable "records" {
  type        = list
  description = "Host URL for ingress"
  default     = []
}

variable "depend_on" {
  type        = string
  description = "Depend on hack"
  default     = ""
}