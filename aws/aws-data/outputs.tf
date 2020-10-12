output "vpc_id" {
  value = data.aws_vpc.main.id
}

output "private_zone" {
  value = data.aws_route53_zone.private.zone_id
}

output "public_zone" {
  value = data.aws_route53_zone.public.zone_id
}

output "subnets" {
  value = data.aws_subnet_ids.selected.ids
}

output "security_groups" {
  value = data.aws_security_groups.selected.ids
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}