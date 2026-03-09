resource "aws_vpc" "rag_vpc" {

  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "rag-vpc"
  }
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.rag_vpc.id

  tags = {
    Name = "rag-igw"
  }
}

resource "aws_subnet" "public_subnet_1" {

  vpc_id = aws_vpc.rag_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {

  vpc_id = aws_vpc.rag_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.rag_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "subnet1" {

  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "subnet2" {

  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}