
resource "aws_internet_gateway" "my_igateway" {
  #name = not supported
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_igateway"
  }
}

resource "aws_eip" "nat" {
  vpc = true
}
resource "aws_nat_gateway" "my_nat_gateway" {
  #name = not support
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public_subnet.id
  depends_on = [ aws_internet_gateway.my_igateway ]
  tags = {
    Name = "my_nat_gw"
  }
}


resource "aws_route_table" "my_public_routetable" {
  #name = not supported
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_public_routetable"
  }
}
resource "aws_route" "my_default_public_route" {
  route_table_id = aws_route_table.my_public_routetable.id
  destination_cidr_block = "0.0.0.0/0"
  # public networks straight to igw
  gateway_id = aws_internet_gateway.my_igateway.id
}
resource "aws_route" "my_default_public_route_ipv6" {
  route_table_id = aws_route_table.my_public_routetable.id
  destination_ipv6_cidr_block = "::/0"
  # public networks straight to igw
  gateway_id = aws_internet_gateway.my_igateway.id
}
resource "aws_route_table_association" "my_public_routetable_assoc" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.my_public_routetable.id
}


resource "aws_route_table" "my_private_routetable" {
  #name = not supported
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_private_routetable"
  }
}
resource "aws_route" "my_default_private_route" {
  route_table_id = aws_route_table.my_private_routetable.id
  destination_cidr_block = "0.0.0.0/0"
  # private networks to nat gw
  nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
}
resource "aws_route_table_association" "my_routetable_assoc" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.my_private_routetable.id
}






resource "aws_security_group" "wg_public_sg" {
    name = "wg_public_sg"
    tags = {
      Name = "wg_public_sg"
    }
    vpc_id = aws_vpc.my_vpc.id

    ingress {
    from_port = 51820
    to_port = 51820
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
    }
    ingress {
    from_port = 51820
    to_port = 51820
    protocol = "tcp" 
    ipv6_cidr_blocks = ["::/0"] 
    }
    ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    }
    ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    }
    ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"] 
    }

    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
    }


}

resource "aws_security_group" "web_public_sg" {
    name = "web_public_sg"
    tags = {
      Name = "web_public_sg"
    }
    vpc_id = aws_vpc.my_vpc.id

    ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    }
    ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    }
    ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"] 
    }

    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
    }


}

resource "aws_security_group" "web_private_sg" {
    name = "web_private_sg"
    tags = {
      Name = "web_private_sg"
    }
    vpc_id = aws_vpc.my_vpc.id

    ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.vpc_cidr] 
    }
    ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.vpc_cidr] 
    }
    ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [var.vpc_cidr] 
    }

    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
    }


}

resource "aws_security_group" "db_private_sg" {
    name = "db_private_sg"
    tags = {
      Name = "db_private_sg"
    }
    vpc_id = aws_vpc.my_vpc.id

    ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.vpc_cidr] 
    }
    ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [var.vpc_cidr]
    }
    ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [var.vpc_cidr]
    }

    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
    }
}

