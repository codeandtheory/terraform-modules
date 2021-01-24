variable "vpc_id" {}
variable "app" {}
variable "env" {}
variable "client" {}

variable "anybody" {
  type = map
  default = {
    cidr = "0.0.0.0/0"
    description = "Anybody, Anywhere"
  }
}

variable "ny_office" {
  type = map
  default = {
    cidr = "38.142.252.242/32"
    description = "NY Office"
  }
} 

variable "ny_office2" {
  type = map
  default = {
    cidr = "172.254.199.202/32"
    description = "NY Office 2"
  }
}

variable "sf_office" {
  type = map
  default = {
    cidr = "50.211.199.177/32"
    description = "SF Office"
  }
}

variable "london_office" {
  type = map
  default = {
    cidr = "81.134.142.178/32"
    description = "London Office"
  }
}

variable "manila_office" {
  type = map
  default = {
    cidr = "180.232.99.122/32"
    description = "Manila Office"
  }
}

variable "manila_office2" {
  type = map
  default = {
    cidr = "161.49.182.2/32"
    description = "Manila Office 2"
  }
}

variable "candt_k8s_vpc_nat" {
  type = map
  default = {
    cidr = "52.44.236.158/32"
    description = "C&T Kubernetes VPC NAT Gateway"
  }
}

variable "candt_k8s_vpc_nat2" {
  type = map
  default = {
    cidr = "3.220.45.29/32"
    description = "C&T Kubernetes VPC NAT Gateway 2"
  }
}

variable "candt_k8s_vpc_nat3" {
  type = map
  default = {
    cidr = "34.204.54.95/32"
    description = "C&T Kubernetes VPC NAT Gateway 3"
  }
}

