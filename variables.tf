######### variables #########

variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS Region where resource will be created"

}

variable "instance_type" {
  type        = string
  description = "EC2 Instance Type"
  default     = "t3.micro"

}

variable "instance_key" {
  type    = string
  default = "instance_key"

}

variable "admin_ips" {
  description = "IPS allowed for SSH"
  type        = list(string)
}