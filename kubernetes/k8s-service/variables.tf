variable "name" {
  type        = string
  description = "Name of Helm release"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace"
}

variable "enabled" {
  type        = bool
  description = "Enable or disable this service"
  default     = true
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

variable "wait" {
  type        = bool
  description = "Whether to wait for release to complete"
  default     = true
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

variable "chart_version" {
  type        = string
  description = "Version to deploy"
  default     = "" # blank means latest
}

variable "create_namespace" {
  type        = bool
  description = "Create namespace on install"
  default     = true
}

variable "build_chart" {
  type        = bool
  description = "Whether to build the chart before deploy (`eg helm dependency build`)"
  default = true
}
