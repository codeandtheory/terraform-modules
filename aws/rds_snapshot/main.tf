provider "aws" {
  region = var.region
}

locals {
  time = formatdate("YYYY-MM-DD-hh-mm", timestamp())
}

resource "aws_db_snapshot" "snap" {
  db_instance_identifier = var.rds_instance
  db_snapshot_identifier = "${var.snapshot_name}-${local.time}"
}
