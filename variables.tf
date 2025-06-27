variable "security_group_name_web" {
  description = "The name of the web security group"
  type        = string
  default     = "test-sg-web"
}

variable "security_group_name_alb" {
  description = "The name of the ALB security group"
  type        = string
  default     = "test-sg-alb"
}

variable "fully_qualified_domain_name" {
  description = "ACM 인증서에 사용할 FQDN"
  type        = string
  default     = "*.junhan.shop"
}

variable "subject_alternative_names" {
  description = "ACM SANs"
  type        = list(string)
  default     = []
}

variable "domain_name" {
  description = "Route53 Hosted Zone에 사용할 도메인"
  type        = string
  default     = "junhan.shop"
}

