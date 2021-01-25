output "password" {
  value = random_password.db_master_password.result
}

output "instance_id" {
  value       = join("", aws_db_instance.rds.*.id)
  description = "ID of the instance"
}

output "instance_arn" {
  value       = join("", aws_db_instance.rds.*.arn)
  description = "ARN of the instance"
}

output "instance_address" {
  value       = join("", aws_db_instance.rds.*.address)
  description = "Address of the instance"
}

output "instance_endpoint" {
  value       = join("", aws_db_instance.rds.*.endpoint)
  description = "DNS Endpoint of the instance"
}
