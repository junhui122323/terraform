resource "aws_db_subnet_group" "test_rds_subnet" {
  name       = "main"
  subnet_ids = [aws_subnet.test_pvt_2a.id, aws_subnet.test_pvt_2c.id]

  tags = {
    Name = "test-rds-subnet"
  }
}

resource "aws_security_group" "test_sg_rds" {
  name   = "test-sg-rds"
  vpc_id = aws_vpc.test_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "test_rds" {
  allocated_storage      = 20
  db_name                = "wordpress"
  engine                 = "mariadb"
  engine_version         = "10.11.9"
  instance_class         = "db.t3.micro"
  username               = "johnlee"
  password               = "Test1234!"
  skip_final_snapshot    = true # RDS 인스턴스를 삭제할 때 최종 스냅샷을 생성하지 않도록 설정
  db_subnet_group_name   = aws_db_subnet_group.test_rds_subnet.name
  vpc_security_group_ids = [aws_security_group.test_sg_rds.id]

  tags = {
    Name = "test-rds"
  }
}

output "rds_endpoint" {
  value       = aws_db_instance.test_rds.endpoint
  description = "The endpoint of the rds"
}
