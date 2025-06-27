resource "aws_vpc" "test_vpc" {  # aws_vpc.test_vpc.id
  cidr_block  = "10.7.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"

  tags = {
    Name = "test-vpc"
  }
}

resource "aws_subnet" "test_pub_2a" { #aws_subnet.test_pub_2a
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.7.0.0/20"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "test-pub-2a"
  }
}

resource "aws_subnet" "test_pub_2b" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.7.16.0/20"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "test-pub-2b"
  }
}

resource "aws_subnet" "test_pub_2c" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.7.32.0/20"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[2]
  tags = {
    Name = "test-pub-2c"
  }
}

resource "aws_subnet" "test_pub_2d" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.7.48.0/20"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[3]
  tags = {
    Name = "test-pub-2d"
  }
}

resource "aws_subnet" "test_pvt_2a" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.7.64.0/20"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "test-pvt-2a"
  }
}

resource "aws_subnet" "test_pvt_2b" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.7.80.0/20"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "test-pvt-2b"
  }
}

resource "aws_subnet" "test_pvt_2c" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.7.96.0/20"
  availability_zone = data.aws_availability_zones.available.names[2]
  tags = {
    Name = "test-pvt-2c"
  }
}

resource "aws_subnet" "test_pvt_2d" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.7.112.0/20"
  availability_zone = data.aws_availability_zones.available.names[3]
  tags = {
    Name = "test-pvt-2d"
  }
}

resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    Name = "test-igw"
  }
}

resource "aws_route_table" "test_pub_rtb" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }
  tags = {
    Name = "test-pub-rtb"
  }
}

resource "aws_route_table" "test_pvt_rtb" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    Name = "test-pvt-rtb"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.test_pvt_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.test_bastion.primary_network_interface_id
}

resource "aws_route_table_association" "test_pub_2a_association" {
  subnet_id = aws_subnet.test_pub_2a.id
  route_table_id = aws_route_table.test_pub_rtb.id
}

resource "aws_route_table_association" "test_pub_2b_association" {
  subnet_id = aws_subnet.test_pub_2b.id
  route_table_id = aws_route_table.test_pub_rtb.id
}

resource "aws_route_table_association" "test_pub_2c_association" {
  subnet_id = aws_subnet.test_pub_2c.id
  route_table_id = aws_route_table.test_pub_rtb.id
}

resource "aws_route_table_association" "test_pub_2d_association" {
  subnet_id = aws_subnet.test_pub_2d.id
  route_table_id = aws_route_table.test_pub_rtb.id
}

resource "aws_route_table_association" "test_pvt_2a_association" {
  subnet_id = aws_subnet.test_pvt_2a.id
  route_table_id = aws_route_table.test_pvt_rtb.id
}

resource "aws_route_table_association" "test_pvt_2b_association" {
  subnet_id = aws_subnet.test_pvt_2b.id
  route_table_id = aws_route_table.test_pvt_rtb.id
}

resource "aws_route_table_association" "test-pvt_2c_association" {
  subnet_id = aws_subnet.test_pvt_2c.id
  route_table_id = aws_route_table.test_pvt_rtb.id
}

resource "aws_route_table_association" "test_pvt_2d_association" {
  subnet_id = aws_subnet.test_pvt_2d.id
  route_table_id = aws_route_table.test_pvt_rtb.id
}
