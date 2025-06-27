data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

# Route 53 Hosted Zone을 data로 조회 (이미 AWS에 Hosted Zone이 있어야 함)
data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

#data "aws_ami" "my_ami" {
#  most_recent = true
#  filter {
#    name   = "name"
#    values = ["my-ami"]
#  }
#  owners = ["self"]
#}

