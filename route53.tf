resource "aws_route53_record" "alb_alias_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "alb.junhan.shop"
  type    = "A"
  alias {
    name                   = aws_lb.test_alb.dns_name
    zone_id                = aws_lb.test_alb.zone_id
    evaluate_target_health = true
  }
}

