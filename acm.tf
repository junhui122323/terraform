resource "aws_acm_certificate" "public_cert" {
  domain_name               = var.fully_qualified_domain_name
  validation_method         = "DNS"
  subject_alternative_names = var.subject_alternative_names
  tags = { Name = "Public Certificate" }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.public_cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.value]
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.public_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

