# Example vars:
# var.domain:       codeandtheory.net
# var.subdomain:    test
# Which would result in test.codeandtheory.net being created and SSL certs for that subdomain

# Get some info about the domain
data "aws_route53_zone" "domain" {
  name         = "${var.domain}."
  private_zone = false
}

# Create a zone for the subdomain. This makes it easier to view records and know who's responsible.
resource "aws_route53_zone" "subdomain" {
  name = "${var.subdomain}.${var.domain}"
  tags = {
    App         = var.app
    Client      = var.client
    "Tech Lead" = var.techlead
  }
}

# Create a forwarding record in the domain
resource "aws_route53_record" "subdomain_ns" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "${var.subdomain}.${var.domain}"
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.subdomain.name_servers
}

# Create SSL cert
resource "aws_acm_certificate" "cert" {
  domain_name               = "${var.subdomain}.${var.domain}"
  subject_alternative_names = ["*.${var.subdomain}.${var.domain}"]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    App         = var.app
    Client      = var.client
    "Tech Lead" = var.techlead
  }
}

# Validate SSL cert
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = aws_route53_zone.subdomain.zone_id
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


# Add the following to the ALB module
## Create record and assign them to an ALB
## example: dev.sands.codeandtheory.net
#resource "aws_route53_record" "subsubdomain" {
#    zone_id = aws_route53_zone.subdomain.zone_id
#    name    = "${var.subsubdomain}.${var.subdomain}.${var.domain}"
#    type    = "CNAME"
#    ttl     = "300"
## ALB goes below
#    records = alb_name
#}
