output "id" {
  value       = aws_elasticache_replication_group.default.*.id
  description = "Redis cluster ID"
}

output "port" {
  value       = var.port
  description = "Redis port"
}

output "cache_nodes" {
  value       = aws_elasticache_replication_group.default.*.primary_endpoint_address
  description = "Redis primary endpoint"
}
