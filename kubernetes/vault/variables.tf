variable "namespaces" {
  type        = list
  description = "Kubernetes namespaces to allow access to secrets"
  default     = []
}

variable "service_accounts" {
  type        = list
  description = "Kubernetes service account to allow access to secrets"
  default     = ["default"]
}

variable "vault_path" {
  type        = string
  description = "Which path to write to Vault"
}

variable "vault_role_name" {
  type        = string
  description = "Vault role name"
  default     = ""
}

variable "vault_kube_auth_path" {
  type        = string
  description = "Which auth path to use for Kubernetes auth"
  default     = "kubernetes"
}

variable "secrets" {
  type        = string
  description = "JSON list of strings as secrets"
}

variable "vault_policy_name" {
  type        = string
  description = "Vault policy name to create"
  default     = ""
}

variable "additional_vault_policy" {
  type        = string
  description = "HCL of additional Vault policy"
  default     = ""
}

variable "additional_policies" {
  type        = list
  description = "List of additional Vault policies to attach"
  default     = []
}

variable "create_policy" {
  type        = bool
  description = "Whether or not to create a policy"
  default     = true
}