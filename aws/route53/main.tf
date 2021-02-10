# Example vars:
# var.domain:    codeandtheory.net
# var.subdomain: sands
# var.env:       dev
# Which would result in dev.sands.codeandtheory.net being created

# sands.codeandtheory.net
data "aws_route53_zone" "subdomain" {
  name         = "${var.subdomain}.${var.domain}."
  private_zone = false
}

resource "aws_route53_zone" "env_subdomain" {
  name = "${var.env}.${var.subdomain}.${var.domain}"
  tags = {
    Env         = var.env
    App         = var.app
    Client      = var.client
    "Tech Lead" = var.techlead
  }
}

resource "aws_route53_record" "env_subdomain_ns" {
  zone_id = data.aws_route53_zone.subdomain.zone_id
  name    = "${var.env}.${var.subdomain}.${var.domain}"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.env_subdomain.name_servers
}

resource "aws_route53_record" "list of records" {
  zone_id = aws_route53_zone.env_subdomain.zone_id
  name    = "${list of records}.${var.env}.${var.subdomain}.${var.domain}"
  type    = "CNAME"
  ttl     = "300"
# ALB goes below
  records = [aws_lb.main.dns_name]
}


# Create SSL cert
resource "aws_acm_certificate" "cert" {
  domain_name               = "${var.env}.${var.subdomain}.${var.domain}"
  subject_alternative_names = ["*.${var.env}.${var.subdomain}.${var.domain}"]
  validation_method         = "DNS"

  tags = var.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

# Validate SSL cert
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = aws_route53_zone.env_subdomain.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

# Validate SSL cert
resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

