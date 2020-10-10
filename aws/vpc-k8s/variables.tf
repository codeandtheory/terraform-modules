#----------------------------------------------------------------
# VPC variables
#----------------------------------------------------------------

variable "app" {
  description = "Application"
  default = "test"
}

variable "env" {
   description = "Environment"
   default = "dev"
}

variable "client" {
   description = "Client name"
   default = "codeandtheory"
}

variable "region" {
  description = "N. Virginia"
  default = "us-east-1"
}

variable "k8s_domain" {
  description = "N. Virginia"
  default = "test.codeandtheory.net"
}

# First and second octet in the CIDR
variable "cidr_ab" {
  default = {
    dev     = "10.99"
  }
}

# Third octet in the CIDR
locals {
  cidr_c_elb_subnets   = 10
  cidr_c_ec2_subnets   = 20
  cidr_c_rds_subnets   = 30
  cidr_c_cache_subnets = 40
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
   state = "available"
}
