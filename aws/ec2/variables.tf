#----------------------------------------------------------------
# EC2 variables
#----------------------------------------------------------------

variable "app" {
  type        = string
}

variable "env" {
  type        = string
}

variable "client" {
  type        = string
}

variable "techlead" {
  description = "Tech Lead"
  type        = string
  default     = "John Doe"
}

variable "instance_count" {
  description = "Number of instances to spin up"
  type        = number
  default     = "2"
}

variable "instance_type" {
  description = "Size of the EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "key_pair" {
  description = "ssh key to be used initially"
  type        = string
  default     = "devops"
}

variable "server_type" {
  description = "The type of server being spun up (web, api, util, ...)"
  default     = "www"
  type        = string
}

variable "subnet_ids" {
}

variable "vpc_security_group_ids" {
  description = "List of Security Group IDs allowed to connect to the instance"
  type        = list(string)
  default     = []
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address with the instance"
  default     = false
}

variable "assign_eip_address" {
  type        = bool
  description = "Assign an Elastic IP address to the instance"
  default     = true
}
