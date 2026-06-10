######### resources ip's  #########

output "server_ips" {
  value = {
    bastion      = aws_instance.bastion.public_ip
    web_app_alb  = aws_instance.web_LB.public_ip
    web_server_a = aws_instance.web_server_a.private_ip
    web_server_b = aws_instance.web_server_b.private_ip
    web_DB       = aws_instance.DB.private_ip
    web_monitor  = aws_instance.monitor.private_ip

  }
}
######### Instance IDs ######### 
output "instance_ids" {
  description = "EC2 Instance IDs"

  value = {
    bastion      = aws_instance.bastion.id
    web_app_lb   = aws_instance.web_LB.id
    web_server_a = aws_instance.web_server_a.id
    web_server_b = aws_instance.web_server_b.id
    web_db       = aws_instance.DB.id
    web_monitor  = aws_instance.monitor.id
  }
}

######### security_groups #########  
output "security_groups" {
  description = "Security Group IDs"

  value = {
    bastion_sg    = aws_security_group.bastion_sg.id
    web_app_alb   = aws_security_group.web_app_alb.id
    web_app_sg    = aws_security_group.web_app_sg.id
    web_app_db_sg = aws_security_group.web_app_db_sg.id
    monitor_sg    = aws_security_group.monitor_sg.id
  }
}

######### Network Information #########
output "network_info" {
  description = "VPC Networking Details"

  value = {
    vpc_id = aws_vpc.web_app_vpc.id

    internet_gateway = aws_internet_gateway.web_app_igw.id

    public_subnet_a = aws_subnet.public_access_lb_a.id
    public_subnet_b = aws_subnet.public_access_lb_b.id

    private_app_a = aws_subnet.private_access_app_a.id
    private_app_b = aws_subnet.private_access_app_b.id

    private_db_a = aws_subnet.private_access_db_a.id
    private_db_b = aws_subnet.private_access_db_b.id


  }
}
######### Nat Gateway #########
output "nat_gateway" {
  value = {
    nat_gateway_id = aws_nat_gateway.web_app_nat_gw.id
    elastic_ip     = aws_eip.web_app_nat_eip.public_ip
  }
}