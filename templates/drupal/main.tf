terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

locals {
  hostname         = "${var.name}.${var.project}.${var.domain}"
  namespace        = "${var.project}-${var.name}"
  subdomain_suffix = length(var.subdomain_suffix) > 1 ? var.subdomain_suffix : var.project
  vault_path       = "vault:secret/data/environments/${var.project}/${var.name}"
  database_host    = "mysql.${var.name}.${var.project}.${var.domain}"
  solr_host        = "solr.${local.hostname}"
  # Drupal extra values files
  drupal_values_files = [
    for f in var.values_files :
    file(f)
  ]
  allowed_ips      = join("\\,", var.allowed_ips)
}

# Lookup common AWS configuration
module "aws_data" {
  source              = "git::https://github.com/codeandtheory/terraform-modules.git//aws/aws-data?ref=v1.0.1"
  domain              = var.domain
  private_domain      = var.private_domain
  vpc_tags            = var.vpc_tags
  subnet_tags         = var.subnet_tags
  security_group_tags = var.security_group_tags
}

# EFS for shared file storage
module "filesystem" {
  source = "git::https://github.com/cloudposse/terraform-aws-efs.git?ref=tags/0.10.0"

  namespace          = local.namespace
  stage              = "dev"
  name               = local.namespace
  region             = var.region
  vpc_id             = module.aws_data.vpc_id
  subnets            = module.aws_data.subnets
  availability_zones = ["us-east-1c", "us-east-1d", "us-east-1e"]
  security_groups    = module.aws_data.security_groups
  zone_id            = module.aws_data.private_zone
  dns_name           = "files.${local.hostname}"
}

# Mysql Database
module "database" {
  source               = "git::https://github.com/codeandtheory/terraform-modules.git//aws/mysql?ref=v1.0.1"
  db_host              = local.database_host
  db_name              = var.project
  db_username          = var.project
  db_size              = var.db_size
  db_instance_class    = var.db_instance_class
  family               = var.family
  engine_version       = var.engine_version
  major_engine_version = var.major_engine_version
  db_identifier        = "${var.name}-${var.project}"
  db_parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    },
    {
      name  = "max_allowed_packet"
      value = "268435456"
    }
  ]
  deletion_protection = false
  route53_zone_id     = module.aws_data.public_zone
  vpc_id              = module.aws_data.vpc_id
  security_group_ids  = module.aws_data.security_groups
  subnet_ids          = module.aws_data.subnets
  tags = {
    Name        = "${var.client}-${var.project}-${var.name}"
    Client      = var.client
    Project     = var.project
    Env         = var.name
    "Tech Lead" = var.tech_lead
    Comments    = "Commonwealth QA database"

  }
  encrypted = true
}

# Apache and Drupal running php-fpm
module "drupal" {
  source    = "git::https://github.com/codeandtheory/terraform-modules.git//kubernetes/k8s-service?ref=v1.0.1"
  name      = "drupal"
  namespace = local.namespace
  chart                = "drupal"
  chart_version        = "1.0.1"
  chart_repository_url = var.chart_repository_url
  timeout              = var.timeout
  values_files         = local.drupal_values_files
  values_overrides = {
    "drupal.replicaCount"      = 2
    "drupal.iamRole"           = "${var.project}-${var.name}-drupal" # @TODO, CREATE IAM ROLE MODULE OUTPUT
    "drupal.files.host"        = module.filesystem.dns_name
    "drupal.image.tag"         = var.image_tag
    "drupal.image.repository"  = var.image_repository
    "drupal.ingress.hostname"  = "${var.name}.${local.subdomain_suffix}.${var.domain}"
    "drupal.ingress.domain"    = "${local.subdomain_suffix}.${var.domain}"
    "drupal.vaultPath"         = local.vault_path
    "drupal.vaultKubeAuthPath" = module.vault.vault_kube_auth_path
    "drupal.vaultKubeRole"     = module.vault.vault_role_name
    "drupal.allowedIPs"        = "${local.allowed_ips}"
  }
}

# Apache Solr
resource "random_password" "solr_password" {
  length  = 12
  special = false
}
module "solr" {
  source               = "git::https://github.com/codeandtheory/terraform-modules.git//kubernetes/k8s-service?ref=v1.0.1"
  name                 = "solr"
  enabled              = var.solr_enabled
  namespace            = local.namespace
  chart                = "apache-solr"
  chart_version        = "1.2.0"
  chart_repository_url = var.chart_repository_url
  timeout              = var.timeout
  values_overrides = {
    "solr.user"     = "solr"
    "solr.password" = "${random_password.solr_password.result}"
    "ingress.host"  = "${local.solr_host}"
    "allowedIPs"    = local.allowed_ips
  }
}

# Varnish Cache @TODO

# Vault
module "vault" {
  source               = "git::https://github.com/codeandtheory/terraform-modules.git//kubernetes/vault?ref=v1.0.1"
  vault_path           = local.vault_path
  vault_kube_auth_path = var.vault_kube_auth_path
  service_accounts = [
    "drupal",
    "drupal-hook",
    "jenkins"
  ]
  namespaces = [local.namespace]
  secrets    = <<EOT
{
  "DB_DATABASE": "${var.project}",
  "DB_USERNAME": "${var.project}",
  "DB_PASSWORD": "${module.database.master_password}",
  "DB_HOST": "${local.database_host}",
  "SOLR_HOST": "${local.solr_host}",
  "SOLR_PASSWORD": "${random_password.solr_password.result}"
}
EOT

}
