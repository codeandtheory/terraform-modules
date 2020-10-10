output "elb_public_id" {
  value = aws_security_group.elb_public.id
}

output "elb_private_id" {
  value = aws_security_group.elb_private.id
}

output "ssh_access_id" {
  value = aws_security_group.ssh_access.id
}

output "web_access_id" {
  value = aws_security_group.web_access.id
}

output "db_access_id" {
  value = aws_security_group.db_access.id
}

output "cache_access_id" {
  value = aws_security_group.cache_access.id
}

output "github_access_id" {
  value = aws_security_group.github_access.id
}

output "cloudflare_access_id" {
  value = aws_security_group.cloudflare_access.id
}