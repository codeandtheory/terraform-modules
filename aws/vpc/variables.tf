#----------------------------------------------------------------
# VPC variables
#----------------------------------------------------------------

variable "app" {
  description = "Application"
  default = "test"
}

variable "env" {
   description = "Environment"
   default = "prod"
}

variable "client" {
   description = "Client name"
   default = "CandT"
}

variable "techlead" {
   description = "Tech lead"
   default = "John Doe"
}

variable "region" {
  description = "N. Virginia"
  default = "us-east-1"
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

variable "make_elb_subnets" {
  description = "Do you need subnets for load balancers?"
  default = ""
}

variable "make_ec2_subnets" {
  description = "Do you need subnets for servers?"
  default = ""
}

variable "make_rds_subnets" {
  description = "Do you need subnets for RDS and database instances?"
  default = ""
}

variable "make_cache_subnets" {
  description = "Do you need subnets for Redis/Memcached?"
  default = ""
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
   state = "available"
}
