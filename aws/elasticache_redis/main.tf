data "aws_availability_zones" "available" {
   state = "available"
}

resource "aws_elasticache_parameter_group" "default" {
  name   = "${var.app}-${var.env}-redis"
  family = var.cachefamily
}

resource "aws_elasticache_replication_group" "default" {
  automatic_failover_enabled    = true
  availability_zones            = slice(data.aws_availability_zones.available.names, 0, var.num_cache_nodes)
  engine_version                = var.engine_version
  replication_group_id          = "${var.app}-${var.env}-redis"
  replication_group_description = "${var.app}-${var.env}-redis"
  node_type                     = var.node_type
  number_cache_clusters         = var.num_cache_nodes
  parameter_group_name          = aws_elasticache_parameter_group.default.name
  port                          = var.port
  subnet_group_name             = "${var.app}-${var.env}-cache-subnet-group"
  tags = {
    Name    = "${var.app}-${var.env}-redis"
    Env     = var.env
    App     = var.app
    Client  = var.client
    Tech Lead = var.techlead
  }
}
