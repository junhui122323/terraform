output "alb_dns_name" {
  value       = aws_lb.test_alb.dns_name
  description = "ALB의 DNS 이름"
}

output "web01_private_ip" {
  value       = aws_instance.test_web01.private_ip
  description = "웹01의 프라이빗 IP"
}

output "web02_private_ip" {
  value       = aws_instance.test_web02.private_ip
  description = "웹02의 프라이빗 IP"
}

