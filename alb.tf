resource "aws_lb" "test_alb" {
  name               = "test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.test_sg_alb.id]
  subnets = [
    aws_subnet.test_pub_2a.id,
    aws_subnet.test_pub_2b.id,
    aws_subnet.test_pub_2c.id,
    aws_subnet.test_pub_2d.id
  ]
  enable_deletion_protection = false
  tags = { Name = "test-alb" }
}

resource "aws_security_group" "test_sg_alb" {
  vpc_id = aws_vpc.test_vpc.id
  name   = var.security_group_name_alb
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
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "test-sg-alb" }
}

resource "aws_lb_target_group" "test_tg" {
  name     = "test-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.test_vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = { Name = "test-tg" }
}

resource "aws_lb_listener" "test_listener_http" {
  load_balancer_arn = aws_lb.test_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_tg.arn
  }
}

resource "aws_lb_listener" "test_listener_https" {
  load_balancer_arn = aws_lb.test_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.public_cert.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "test_web01" {
  target_group_arn = aws_lb_target_group.test_tg.arn
  target_id        = aws_instance.test_web01.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "test_web02" {
  target_group_arn = aws_lb_target_group.test_tg.arn
  target_id        = aws_instance.test_web02.id
  port             = 80
}

