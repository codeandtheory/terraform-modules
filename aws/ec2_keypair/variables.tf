variable "client" {
  type        = string
  description = "Client"
}

variable "app" {
  type        = string
  description = "App"
}

variable "techlead" {
  type        = string
  description = "Tech Lead"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to SSH public key directory (e.g. `/secrets`)"
  default     = "./"
}

variable "ssh_public_key_file" {
  type        = string
  description = "Name of existing SSH public key file (e.g. `id_rsa.pub`) to be imported into AWS"
  default     = null
}

variable "generate_ssh_key" {
  type        = bool
  default     = true
  description = "If set to `true`, new SSH key pair will be created and `ssh_public_key_file` will be ignored"
}

variable "ssh_key_algorithm" {
  type        = string
  default     = "RSA"
  description = "SSH key algorithm"
}

variable "private_key_extension" {
  type        = string
  default     = ".pem"
  description = "Private key extension"
}

variable "public_key_extension" {
  type        = string
  default     = ".pub"
  description = "Public key extension"
}
