resource "aws_instance" "ec2" {
  ami = "ami-066784287e358dad1"
  instance_type = "t2.micro"
  key_name = "wbb"
}


resource "aws_vpc" "cust" {
    cidr_block = "10.0.0.0/16"
    tags = {
      name="myvpc-1"
    }
  
}

resource "aws_internet_gateway" "cust" {
  vpc_id = aws_vpc.cust.id
  tags = {
    name="cust_ig"
  }
}

resource "aws_eip" "newip" {
  domain = "vpc"
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.ec2.id
  allocation_id = aws_eip.newip.id
}


resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.newip.id
  subnet_id     = aws_subnet.private.id

  tags = {
    Name = "NAT-01"
  }
  depends_on = [aws_internet_gateway.cust]
}



resource "aws_subnet" "public" {
    vpc_id = aws_vpc.cust.id
    cidr_block = "10.0.0.0/24"
    tags={
        name="my-subnet-1"
    }
  
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.cust.id
    cidr_block = "10.0.1.0/24"
   
    tags={
        name = "my-subnet-2"
    }
  
}

resource "aws_route_table" "cust" {
  vpc_id = aws_vpc.cust.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.cust.id
  }

  route {
    gateway_id = aws_internet_gateway.cust.id
    cidr_block = "0.0.0.0/0"

}

  tags = {
    Name = "Route-A"
  }
}

resource "aws_route_table_association" "cust" {
  route_table_id = aws_route_table.cust.id
  subnet_id = aws_subnet.public.id
}

resource "aws_security_group" "allow_tls" {
  name = "allow_tls"
  vpc_id = aws_vpc.cust.id
  tags = {
    name = "new_sg-1"
  }
  
  ingress  {
    description = "tls from vpc"
     from_port = 80
     to_port = 80
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]

  }

   ingress {
    description = "tls2 from vpc"
     from_port = 22
     to_port = 22
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }


  }


