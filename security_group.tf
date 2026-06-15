######### Bastion Security Group #########

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Bastion Host -ssh access only from admin IPs"
  vpc_id      = aws_vpc.web_app_vpc.id

  ingress {
    description = "SSH from admin IPs only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_ips # ["0.0.0.0/0"] or we can put our public ip for this check on internet as what is my ip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "bastion_sg" }
}


######### Load Balancer Security Group #########
resource "aws_security_group" "web_app_alb" {
  name        = "web_app_alb"
  description = "ALB Security Group"
  vpc_id      = aws_vpc.web_app_vpc.id


  ingress {
    description = "SSH from admin IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_ips # ["0.0.0.0/0"] or we can put our public ip for this check on internet as what is my ip
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HAProxy stats from laptop only"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.admin_ips # ["0.0.0.0/0"] or we can put our public ip for this check on internet as what is my ip
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_app_alb"
  }
}

######### Web Server Security Group #########

resource "aws_security_group" "web_app_sg" {
  name        = "web_app_sg"
  description = "Web Server Security Group"
  vpc_id      = aws_vpc.web_app_vpc.id


  ingress {
    description     = "SSH from bastion only"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]

  }
  ingress {
    description     = "HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_app_alb.id]


  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.web_app_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_app_sg"
  }
}

######### Database Security Group #########

resource "aws_security_group" "web_app_db_sg" {
  description = "Database Security Group"
  name        = "web_app_db_sg"
  vpc_id      = aws_vpc.web_app_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }


  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_app_sg.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_app_db_sg"
  }
}

######### Monitoring Security Group #########

resource "aws_security_group" "monitor_sg" {

  name   = "monitor_sg"
  vpc_id = aws_vpc.web_app_vpc.id

  ingress {
    description     = "ssh use"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description = "grafana use"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = var.admin_ips # ["0.0.0.0/0"] or we can put our public ip for this check on internet as what is my ip
  }

  ingress {
    description = "promethus use"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = var.admin_ips # ["0.0.0.0/0"] or we can put our public ip for this check on internet as what is my ip
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "monitor_sg"
  }
}