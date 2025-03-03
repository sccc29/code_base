#-------------------------
# VPC & Subnets
#-------------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Demo VPC"
  }
}

resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key
  tags = {
    Name = "Private Subnet ${each.key}"
  }

}

resource "aws_subnet" "public" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet ${each.key}"
  }

}



resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Demo IGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Public Route Table"
  }

}

resource "aws_route_table_association" "public" {
  for_each       = { for x, y in aws_subnet.public : x => y.id }
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id

}

resource "aws_eip" "ngw" {
  domain = "vpc"

  tags = {
    Name = "Demo NGW EIP"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.public["us-east-1a"].id

  tags = {
    Name = "Demo NGW"
  }

}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id

  }

  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "private" {
  for_each       = { for x, y in aws_subnet.private : x => y.id }
  subnet_id      = each.value
  route_table_id = aws_route_table.private.id

}

