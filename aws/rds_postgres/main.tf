locals {
  name       = replace(var.db_identifier, "_", "-")
  kms_key_id = var.encrypted ? aws_kms_key.api_keys.arn : ""
}

resource "random_password" "db_master_password" {
  length  = 24
  special = false
}

resource "random_password" "db_password" {
  length  = 24
  special = false
}


resource "aws_security_group" "postgres" {
  name        = local.name
  description = "Allow Postgres Traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Postgres"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.security_group_ids
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.name
  }
}

resource "aws_route53_record" "db_alias" {
  zone_id = var.route53_zone_id
  name    = var.db_host
  type    = "CNAME"
  ttl     = "60"
  records = [module.postgres.this_db_instance_address]
}

resource "aws_kms_key" "api_keys" {
  description = var.db_identifier
}

module "postgres" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = var.db_identifier

  engine                     = "postgres"
  engine_version             = var.engine_version
  instance_class             = var.db_instance_class
  allocated_storage          = var.db_size
  publicly_accessible        = false
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  name     = var.db_name
  username = var.db_username
  password = random_password.db_master_password.result
  port     = "5432"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [aws_security_group.postgres.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "0"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = false

  storage_encrypted = var.encrypted
  kms_key_id        = local.kms_key_id

  tags = var.tags

  # DB subnet group
  subnet_ids = var.subnet_ids

  create_db_option_group = false

  # DB parameter group
  family = "postgres11"

  # DB option group
  major_engine_version = "11"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = var.db_identifier

  # Database Deletion Protection
  deletion_protection = var.deletion_protection

  parameters = var.db_parameters
}