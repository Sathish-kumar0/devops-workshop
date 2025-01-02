provider "aws" {
  region = "us-east-1"
  
}
resource "aws_instance" "demo-server" {
  ami = "ami-01816d07b1128cd2d"
  instance_type = "t2.micro"
  key_name = "dpp"
  security_groups = [ "demo-ssh" ]
  

}


resource "aws_security_group" "worker_node_sg" {
  name        = "demo-ssh"
  description = "Allow ssh inbound traffic" 

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