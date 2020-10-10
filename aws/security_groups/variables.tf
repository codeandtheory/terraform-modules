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

variable "allowed_ips" {
  type = map(any)
  default = {
    "Everybody" = "0.0.0.0/0"
  }
} 