data "aws_route53_zone" "public" {
  name = var.domain
}

data "aws_route53_zone" "private" {
  name         = var.private_domain
  private_zone = true
}

data "aws_vpc" "main" {
  tags = var.vpc_tags
}

data "aws_subnet_ids" "selected" {
  vpc_id = data.aws_vpc.main.id
  tags   = var.subnet_tags
}

data "aws_security_groups" "selected" {
  tags = var.security_group_tags
}

data "aws_caller_identity" "current" {}