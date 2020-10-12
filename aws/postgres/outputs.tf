output "password" {
  value = random_password.db_password.result
}

output "master_password" {
  value = module.postgres.this_db_instance_password
}

output "db_host" {
  value = aws_route53_record.db_alias.name
}