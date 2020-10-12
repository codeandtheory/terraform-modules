output "service_accounts" {
  value = var.service_accounts
}

output "vault_policy_name" {
  value = var.vault_policy_name
}

output "namespaces" {
  value = var.namespaces
}

output "vault_role_name" {
  value = local.vault_role_name
}

output "policy_name" {
  value = local.policy_name
}

output "vault_kube_auth_path" {
  value = var.vault_kube_auth_path
}

output "vault_path" {
  value = var.vault_path
}