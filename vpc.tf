resource "aws_vpc" "my-VPC" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "my-VPC"
  }
}

resource "aws_subnet" "public-subnet-01" {
  vpc_id                  = aws_vpc.my-VPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE1
  tags = {
    Name = "public-subnet-01"
  }
}

resource "aws_subnet" "public-subnet-02" {
  vpc_id                  = aws_vpc.my-VPC.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE2
  tags = {
    Name = "public-subnet-02"
  }
}

resource "aws_subnet" "private-subnet-01" {
  vpc_id                  = aws_vpc.my-VPC.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = var.ZONE1
  tags = {
    Name = "private-subnet-01"
  }
}

resource "aws_subnet" "private-subnet-02" {
  vpc_id                  = aws_vpc.my-VPC.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = var.ZONE2
  tags = {
    Name = "private-subnet-02"
  }
}

resource "aws_internet_gateway" "my_IGW" {
  vpc_id = aws_vpc.my-VPC.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.my-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_IGW.id
  }

  tags = {
    Name = "public-RT"
  }
}

resource "aws_route_table" "private-RT" {
  vpc_id = aws_vpc.my-VPC.id

  tags = {
    Name = "public-RT"
  }
}

resource "aws_route_table_association" "public-1-a" {
  subnet_id      = aws_subnet.public-subnet-01.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_route_table_association" "public-2-a" {
  subnet_id      = aws_subnet.public-subnet-02.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_route_table_association" "private-1-a" {
  subnet_id      = aws_subnet.private-subnet-01.id
  route_table_id = aws_route_table.private-RT.id
}

resource "aws_route_table_association" "private-1-a" {
  subnet_id      = aws_subnet.private-subnet-02.id
  route_table_id = aws_route_table.private-RT.id
}




