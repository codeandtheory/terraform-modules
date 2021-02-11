output "acm_certificate_arn" {
  description = "arn of the ssl certificate"
  value       = aws_acm_certificate.cert.arn
}

#output "acm_certificate_dns_validation_record" {
  #description = "record which is used to validate acm certificate"
  #value       = aws_route53_record.validation.name
#}
