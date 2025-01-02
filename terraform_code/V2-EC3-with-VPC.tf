provider "aws" {
  region = "us-east-1"
  
}
resource "aws_instance" "demo-server" {
  ami = "ami-0e2c8caa4b6378d8c"
  instance_type = "t2.micro"
  key_name = "dpp"
  vpc_security_group_ids = [ aws_security_group.worker_node_sg.id ]
  subnet_id = aws_subnet.dpp-public-subnet01.id


}

resource "aws_security_group" "worker_node_sg" {
  name        = "demo-ssh"
  description = "Allow ssh inbound traffic" 
  vpc_id = aws_vpc.dpp-vpc.id

  ingress {
    description      = "ssh access to public"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }


}

resource "aws_vpc" "dpp-vpc" {
    cidr_block = "10.1.0.0/16"
    tags = {
        name ="dpp-vpc"

    }
  
}

resource "aws_subnet" "dpp-public-subnet01" {
    vpc_id = aws_vpc.dpp-vpc.id
    cidr_block = "10.1.1.0/24"
    //map_customer_owned_ip_on_launch = true
    availability_zone = "us-east-1a"
    tags = {
      name = "dpp-public-subnet01"
    }

}

resource "aws_subnet" "dpp-public-subnet02" {
    vpc_id = aws_vpc.dpp-vpc.id
    cidr_block = "10.1.2.0/24"
    //map_customer_owned_ip_on_launch = true
    availability_zone = "us-east-1a"
    tags = {
      name = "dpp-public-subnet02"
    }

}

resource "aws_internet_gateway" "dpp-igw" {
    vpc_id = aws_vpc.dpp-vpc.id
    tags = {
        name = "dpp-igw"
    }
  
}

resource "aws_route_table" "dpp-public-rt" {
    vpc_id = aws_vpc.dpp-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dpp-igw.id
    }
  
}

resource "aws_route_table_association" "dpp-rta-public-subnet01" {
    subnet_id = aws_subnet.dpp-public-subnet01.id
    route_table_id = aws_route_table.dpp-public-rt.id
  
}
resource "aws_route_table_association" "dpp-rta-public-subnet02" {
    subnet_id = aws_subnet.dpp-public-subnet02.id
    route_table_id = aws_route_table.dpp-public-rt.id
  
}