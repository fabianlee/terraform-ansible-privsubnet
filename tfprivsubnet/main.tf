terraform {
  required_version = ">= 0.12.24"
  required_providers {
    aws = ">= 2.67.0"
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}

resource "aws_key_pair" "my_keypair" {
  key_name   = var.aws_region
  public_key = file("${path.module}/${var.aws_region}.pub")
  tags = {
    Name = var.aws_region
  }
}


data "aws_ami" "my_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [ var.ami_image_name ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  # ipv6 block
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "vpc_${var.aws_region}"
  }
}

resource "aws_subnet" "public_subnet" {
  #name = not supported
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_cidr_public
  ipv6_cidr_block   = cidrsubnet(aws_vpc.my_vpc.ipv6_cidr_block,8,254)

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  #name = not supported
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_cidr_private

  tags = {
    Name = "private_subnet"
  }
}


