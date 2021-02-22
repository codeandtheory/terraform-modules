variable "region" {
  description = "What region?"
  default = "us-east-1"
}

variable "rds_instance" {
  description = "Which RDS instance are we backing up?"
  default = ""
}

variable "snapshot_name" {
  default = ""
}
