provider "aws" {
  region = "ap-northeast-2"
}

# Fetch the latest Amazon Linux 2023 AMI #EC2에 입힐 이미 존재하는 이미지 로드하는곳 
data "aws_ami" "amazon_linux_2023" { # data.aws_ami.amazon_linux_2023
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # self; 내소유
}

# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch one of the default subnets in the default VPC (e.g., in ap-northeast-2a)
data "aws_subnet" "default_subnet" {  #data.aws_subnet.default_subnet
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["ap-northeast-2a"]
  }

}

# Generate a key pair for the instance
resource "aws_key_pair" "tf_key" { # aws_key_pair.tf_key.key_name
  key_name   = "tf-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "example" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  # ami                    = "ami-049788618f07e189d"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  subnet_id              = data.aws_subnet.default_subnet.id
  key_name               = aws_key_pair.tf_key.key_name

  user_data = <<-EOF
              #cloud-boothook
              #!/bin/bash
              timedatectl set-timezone Asia/Seoul
              dnf install -y httpd git
              cd /var/www/
              git clone https://github.com/netdoctor0405/html.git
              systemctl enable --now httpd
              EOF

  tags = {
    Name = "terraform-webserver"
  }
}

resource "aws_security_group" "instance" { # aws_security_group.instance.id
  name        = var.security_group_name # terraform-example-instance
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["112.221.225.163/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # 모든 프로토콜
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-web"
  }
}

# Create an AMI from the running instance
resource "aws_ami_from_instance" "my_sale_ami" {
  name               = "my-sale-ami"
  source_instance_id = aws_instance.example.id
  description        = "AMI created from the terraform-webserver instance"

  tags = {
    Name = "my-sale-ami"
  }
}

variable "security_group_name" { # var.security_group_name
  description = "The name of the security group"
  type        = string
  default     = "terraform-example-instance" # default가 없으면 직접 입력한다.
}

output "private_ip" {
  value       = aws_instance.example.private_ip
  description = "The private IP of the Instance"
}

output "pub_dns" {
  value       = aws_instance.example.public_dns
  description = "The public DNS of the Instance"
}

output "key_pair_name" {
  value       = aws_key_pair.tf_key.key_name
  description = "The name of the key pair created for the instance"
}

