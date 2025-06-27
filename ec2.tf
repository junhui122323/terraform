# 키페어 생성
resource "aws_key_pair" "test_key" {
  key_name   = "test-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# 웹 서버용 시큐리티 그룹
resource "aws_security_group" "test_sg_web" {
  vpc_id = aws_vpc.test_vpc.id
  name   = var.security_group_name_web

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["60.196.24.130/32"] # 본인 IP로 제한 권장
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "test-sg-web"
  }
}

# 웹 서버 1
resource "aws_instance" "test_web01" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.test_pvt_2a.id
  vpc_security_group_ids = [aws_security_group.test_sg_web.id]
  key_name               = aws_key_pair.test_key.key_name
  user_data = <<-EOF
              #cloud-boothook
              #!/bin/bash
              dnf install -y httpd
              systemctl enable --now httpd
              echo "<h1>test-web01</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "test-web01"
  }
}

# 웹 서버 2
resource "aws_instance" "test_web02" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.test_pvt_2c.id
  vpc_security_group_ids = [aws_security_group.test_sg_web.id]
  key_name               = aws_key_pair.test_key.key_name
  user_data = <<-EOF
              #cloud-boothook
              #!/bin/bash
              dnf install -y httpd
              systemctl enable --now httpd
              echo "<h1>test-web02</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "test-web02"
  }
}

# 배스천 서버 (NAT/관리용)
resource "aws_instance" "test_bastion" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.test_pub_2a.id
  vpc_security_group_ids = [aws_security_group.test_sg_web.id]
  key_name               = aws_key_pair.test_key.key_name

  tags = {
    Name = "test-bastion"
  }
}

