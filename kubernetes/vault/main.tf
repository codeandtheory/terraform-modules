locals {
  vault_path       = replace(var.vault_path, "/(vault:)(secret/)?(data/)?/", "")
  policy_name_set  = length(var.vault_policy_name) > 0 ? true : false
  policy_name      = local.policy_name_set ? var.vault_policy_name : replace(local.vault_path, "/", "-") // environments/cnn/datacloud/uat == environments-cnn-datacloud-uat
  policies         = local.policy_name_set ? concat(local.default_policies, [var.vault_policy_name]) : local.default_policies
  default_policies = concat(["default", local.policy_name], var.additional_policies)

  role_name_set   = length(var.vault_role_name) > 0 ? true : false
  vault_role_name = local.role_name_set ? var.vault_role_name : local.policy_name
}

resource "vault_generic_secret" "env_vars" {
  path      = "secret/${local.vault_path}"
  data_json = var.secrets
}

resource "vault_policy" "policy" {
  count  = var.create_policy ? 1 : 0
  name   = local.policy_name
  policy = <<EOT
path "secret/data/*" {
  policy = "deny"
}
path "secret/${local.vault_path}" {
  policy = "sudo"
}
path "secret/data/${local.vault_path}" {
  policy = "sudo"
}
path "auth/token/create" {
  policy = "write"
}
path "secret/data/*" {
  policy = "read"
}
path "sys/capabilities-self" {
  capabilities = ["update"]
}
path "sys/mounts" {
  capabilities = ["read"]
}
path "sys/auth" {
  capabilities = ["read"]
}
${var.additional_vault_policy}
EOT
}

resource "vault_kubernetes_auth_backend_role" "role" {
  count                            = var.create_policy ? 1 : 0
  backend                          = var.vault_kube_auth_path
  role_name                        = local.vault_role_name
  bound_service_account_names      = var.service_accounts
  bound_service_account_namespaces = var.namespaces
  token_ttl                        = 120
  # token_policies                   = [local.env_basename]
  policies = local.policies # currently on vault 1.1.2
}
