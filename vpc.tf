######### vpc details #########

resource "aws_vpc" "web_app_vpc" {

  cidr_block = "10.1.0.0/16"
  tags       = { Name = "web_app_vpc" }

}

######### Internet Gateway #########
resource "aws_internet_gateway" "web_app_igw" {
  vpc_id = aws_vpc.web_app_vpc.id
  tags   = { Name = "web_app_igw" }

}

######### Elastic IP for NAT Gateway #########

resource "aws_eip" "web_app_nat_eip" {
  domain = "vpc"
  tags   = { Name = "web_app_nat_eip" }

}

######### NAT Gateway in public subnet ######### 
resource "aws_nat_gateway" "web_app_nat_gw" {
  allocation_id = aws_eip.web_app_nat_eip.id
  subnet_id     = aws_subnet.public_access_lb_a.id
  tags          = { Name = "web_app_nat_gw" }
  depends_on    = [aws_internet_gateway.web_app_igw, aws_eip.web_app_nat_eip]

}

######### Public Subnet #########

resource "aws_subnet" "public_access_lb_a" {
  vpc_id                  = aws_vpc.web_app_vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = { Name = "public_access_lb_a" }


}

resource "aws_subnet" "public_access_lb_b" {
  vpc_id                  = aws_vpc.web_app_vpc.id
  cidr_block              = "10.1.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = { Name = "public_access_lb_b" }


}


######### Private Subnet #########
resource "aws_subnet" "private_access_app_a" {
  vpc_id            = aws_vpc.web_app_vpc.id
  cidr_block        = "10.1.11.0/24"
  availability_zone = "ap-south-1a"
  tags              = { Name = "private_access_app_a" }

}

resource "aws_subnet" "private_access_app_b" {
  vpc_id            = aws_vpc.web_app_vpc.id
  cidr_block        = "10.1.12.0/24"
  availability_zone = "ap-south-1b"
  tags              = { Name = "private_access_app_b" }

}


######### Private DB subnet #########
resource "aws_subnet" "private_access_db_a" {
  vpc_id            = aws_vpc.web_app_vpc.id
  cidr_block        = "10.1.21.0/24"
  availability_zone = "ap-south-1a"
  tags              = { Name = "private_access_db_a" }

}

resource "aws_subnet" "private_access_db_b" {
  vpc_id            = aws_vpc.web_app_vpc.id
  cidr_block        = "10.1.22.0/24"
  availability_zone = "ap-south-1b"
  tags              = { Name = "private_access_db_b" }

}

######### Public Route Table #########

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.web_app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_app_igw.id
  }
  tags = { Name = "public_route" }
}


######### Private route table — routes outbound through NAT #########

resource "aws_route_table" "web_app_pvt_rt" {
  vpc_id = aws_vpc.web_app_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.web_app_nat_gw.id

  }
  tags = { Name = "web_app_pvt_rt" }

}
######### Routing Table Association #########

resource "aws_route_table_association" "public_access_lb_a" {
  subnet_id      = aws_subnet.public_access_lb_a.id
  route_table_id = aws_route_table.public_route.id

}

resource "aws_route_table_association" "public_access_lb_b" {
  subnet_id      = aws_subnet.public_access_lb_b.id
  route_table_id = aws_route_table.public_route.id

}

resource "aws_route_table_association" "private_app_a" {
  subnet_id      = aws_subnet.private_access_app_a.id
  route_table_id = aws_route_table.web_app_pvt_rt.id
}

resource "aws_route_table_association" "private_app_b" {
  subnet_id      = aws_subnet.private_access_app_b.id
  route_table_id = aws_route_table.web_app_pvt_rt.id
}

resource "aws_route_table_association" "private_db_a" {
  subnet_id      = aws_subnet.private_access_db_a.id
  route_table_id = aws_route_table.web_app_pvt_rt.id
}

resource "aws_route_table_association" "private_db_b" {
  subnet_id      = aws_subnet.private_access_db_b.id
  route_table_id = aws_route_table.web_app_pvt_rt.id
}
