#----------------------------------------------------------------
# EC2 variables
#----------------------------------------------------------------

variable "app" {
}

variable "env" {
}

variable "client" {
}

  
variable "techlead" {
  description = "Tech Lead"
  default     = "John Doe"
}

variable "instance_count" {
  description = "Number of instances to spin up"
  default = "2"
}

variable "instance_type" {
  description = "Size of the EC2 instances"
  default = "t2.micro"
}

variable "server_type" {
  description = "The type of server being spun up"
  default = "www"
}

variable "key_pair" {
  description = "ssh key to be used initially"
  default = "kjartan"
}

variable "subnet_ids" {
}

variable "vpc_security_group_ids" {
type    = list(string)
}
