output "password" {
  value = random_password.db_master_password.result
}

output "master_password" {
  value = module.database.this_db_instance_password
}

output "db_host" {
  value = aws_route53_record.db_alias.name
}
