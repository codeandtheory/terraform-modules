variable "s3_name" {}
variable "tags" {}

# There are 2 default bucket policies available. Public and private.
variable "allow_public" {
  description = "Allow public read access to bucket?"
  default     = false
}

variable "aws_account_id" {
  description = "AWS Account Id"
}

variable "aws_username" {
  description = "AWS Username"
}
