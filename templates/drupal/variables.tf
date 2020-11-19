variable "name" {
  type        = string
  description = "Name of environment"
}

variable "project" {
  type        = string
  description = "Project Name"
}

variable "client" {
  type        = string
  description = "Client name"
}

variable "tech_lead" {
  type        = string
  description = "Tech Lead for the project"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "solr_enabled" {
  type        = bool
  description = "Do you need Apache Solr? (@TODO Not yet implemented)"
  default     = false
}

variable "varnish_enabled" {
  type        = bool
  description = "Do you need Varnish? (@TODO Not yet implemented)"
  default     = false
}

variable "chart_repository_url" {
  type        = string
  description = "(optional) describe your variable"
  default     = "https://charts.codeandtheory.net"
}

variable "timeout" {
  type        = number
  description = "Helm install/upgrade timeout"
  default     = 900
}

variable "vpc_tags" {
  type        = map(any)
  description = "Tags for VPC Lookup"
  default = {
    Name = "kubernetes"
  }
}

variable "security_group_tags" {
  type        = map(any)
  description = "Tags for SG lookup"
  default = {
    KubernetesCluster = "kubernetes.codeandtheory.net"
  }
}

variable "subnet_tags" {
  type        = map(any)
  description = "Tags for subnet lookup"
  default = {
    "kubernetes.io/cluster/kubernetes.codeandtheory.net" = "shared"
    SubnetType                                           = "Private"
  }
}

variable "domain" {
  type        = string
  description = "Route53 public domain"
  default     = "codeandtheory.net"
}

variable "private_domain" {
  type        = string
  description = "Route53 internal domain"
  default     = "codeandtheory.int"
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t2.medium"
}

variable "db_size" {
  type        = number
  description = "RDS instance size in gigabytes"
  default     = 10
}

variable "values_files" {
  type        = list
  description = "list of extra values overrides"
  default     = []
}

variable "subdomain_suffix" {
  type        = string
  description = "Override subdomain_suffix (e.g. <env>.<subdomain_suffix>.<domain>)"
  default     = ""
}

variable "vault_kube_auth_path" {
  type        = string
  description = "Kube auth login path"
  default     = "kubernetes"
}

variable "family" {
  type        = string
  description = "Family of mysql"
  default     = "mysql5.7"
}

variable "engine_version" {
  type        = string
  description = "Specific engine version"
  default     = "5.7"
}

variable "major_engine_version" {
  type        = string
  description = "Major engine version"
  default     = "5.7"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag"
  default     = "develop"
}

variable "image_repository" {
  type        = string
  description = "Docker image repo (e.g. ACM or internal Docker registry)"
}