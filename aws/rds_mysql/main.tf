resource "random_password" "db_master_password" {
  length  = 24
  special = false
}

resource "aws_db_instance" "rds" {
  allocated_storage       = var.db_size
  backup_retention_period = 7 # days
  backup_window           = "03:00-06:00"
  db_subnet_group_name    = var.db_subnet_group_name
  engine                  = "mysql"
  engine_version          = "5.7"
  identifier              = "${var.client}-${var.app}-${var.env}-db"
  instance_class          = var.db_instance_type
  maintenance_window      = "Mon:00:00-Mon:03:00"
  multi_az                = false
  name                    = var.db_name
  username                = var.db_username
  password                = random_password.db_master_password.result
  parameter_group_name    = "default.mysql5.7"
  publicly_accessible     = false
  skip_final_snapshot     = true
  storage_type            = "gp2"
  vpc_security_group_ids  = var.vpc_security_group_ids
  tags = {
    Name                  = "${var.client}-${var.app}-${var.env}-db"
    App                   = var.app
    Env                   = var.env
    Client                = var.client
    "Tech Lead"           = var.techlead
  }
}
