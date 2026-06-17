######### ec2 resources details #########

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = var.instance_key
  subnet_id                   = aws_subnet.public_access_lb_a.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }

  tags = { Name = "bastion", Role = "bastion", Project = "fullstack_webapp" }
}

resource "aws_instance" "web_LB" {

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.instance_key
  subnet_id              = aws_subnet.public_access_lb_a.id
  vpc_security_group_ids = [aws_security_group.web_app_alb.id]
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }
  tags = { Name = "web_LB", Role = "LB", Project = "fullstack_webapp" }

}

resource "aws_instance" "web_server_a" {
  #count                  = 2  #can be modified as per requirements
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.instance_key
  subnet_id              = aws_subnet.private_access_app_a.id
  vpc_security_group_ids = [aws_security_group.web_app_sg.id]
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }
  tags = { Name = "web_server_a", Role = "webserver", Project = "fullstack_webapp" }
  #tags                   = { Name = "web_server_a_${count.index + 1}", Role = "webserver" }

}
resource "aws_instance" "web_server_b" {
  #count                  = 2 # ****
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.instance_key
  subnet_id              = aws_subnet.private_access_app_b.id
  vpc_security_group_ids = [aws_security_group.web_app_sg.id]
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }
  tags = { Name = "web_server_b", Role = "webserver", Project = "fullstack_webapp" }
  #tags                   = { Name = "web_server_b_${count.index + 1}", Role = "webserver" , Project = "fullstack_webapp" }
}


resource "aws_instance" "DB" {

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.instance_key
  subnet_id              = aws_subnet.private_access_db_a.id
  vpc_security_group_ids = [aws_security_group.web_app_db_sg.id]
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }
  tags = { Name = "web_DB", Role = "DB", Project = "fullstack_webapp" }

}


resource "aws_instance" "monitor" {

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.instance_key
  subnet_id              = aws_subnet.private_access_app_b.id
  vpc_security_group_ids = [aws_security_group.monitor_sg.id]
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }

  tags = { Name = "web_monitor", Role = "monitor", Project = "fullstack_webapp" }

}

