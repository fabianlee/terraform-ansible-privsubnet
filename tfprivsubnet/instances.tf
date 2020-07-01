

# public wireguard server
resource "aws_instance" "wgserver" {
  #name = not supported
  ami = data.aws_ami.my_ami.id
  instance_type = var.ami_image_type
  subnet_id = aws_subnet.public_subnet.id
  key_name = aws_key_pair.my_keypair.key_name

  # only true for public vpc
  associate_public_ip_address = true
  ipv6_address_count = 1

  vpc_security_group_ids = [ aws_security_group.wg_public_sg.id ]
  source_dest_check = false
  tags = {
    Name = "wgserver"
  }

}

# now that wgserver is created, can add route to other vpc through instance
resource "aws_route" "my_router_othervpc" {
  route_table_id = aws_route_table.my_public_routetable.id
  destination_cidr_block = var.other_vpc_cidr
  instance_id = aws_instance.wgserver.id
  depends_on = [ aws_instance.wgserver ]
}


# public apache web server
resource "aws_instance" "webpub" {
  #name = not supported
  ami = data.aws_ami.my_ami.id
  instance_type = var.ami_image_type
  subnet_id = aws_subnet.public_subnet.id
  key_name = aws_key_pair.my_keypair.key_name
  # only true for public vpc
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.web_public_sg.id ]
  tags = {
    Name = "webpub"
  }

  # wait till route change done so we have stable outside connection
  depends_on = [ aws_route.my_router_othervpc ]
}



# private apache web server
resource "aws_instance" "webpriv" {
  #name = not supported
  ami = data.aws_ami.my_ami.id
  instance_type = var.ami_image_type
  subnet_id = aws_subnet.private_subnet.id
  key_name = aws_key_pair.my_keypair.key_name
  # only true for public vpc
  associate_public_ip_address = false
  vpc_security_group_ids = [ aws_security_group.web_private_sg.id ]
  tags = {
    Name = "webpriv"
  }

  # wait till route change done so we have stable outside connection
  depends_on = [ aws_route.my_router_othervpc ]
}

# private MariaDB server
resource "aws_instance" "dbpriv" {
  #name = not supported
  ami = data.aws_ami.my_ami.id
  instance_type = var.ami_image_type
  subnet_id = aws_subnet.private_subnet.id
  key_name = aws_key_pair.my_keypair.key_name
  # only true for public vpc
  associate_public_ip_address = false
  vpc_security_group_ids = [ aws_security_group.db_private_sg.id ]
  tags = {
    Name = "dbpriv"
  }

  # wait till route change done so we have stable outside connection
  depends_on = [ aws_route.my_router_othervpc ]
}


