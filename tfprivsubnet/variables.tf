variable "aws_access_key" { default="" }
variable "aws_secret_key" { default="" }

variable "vpc_cidr" { default="" }
variable "other_vpc_cidr" { default="" }

variable "subnet_cidr_private" { default="" }
variable "subnet_cidr_public" { default="" }

variable "aws_region" { default="" }

variable "ami_image_name" { default="ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*" }
variable "ami_image_type" { default="t2.nano" }
variable "ami_image_username" { default="ubuntu"}
