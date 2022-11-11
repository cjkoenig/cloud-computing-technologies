variable "awsprops" {
    type = map
    default = {
    region = "eu-central-1"
    ami = "ami-0d0dd86aa7fe3c8a9" # Ubuntu 20.04 LTS available in eu-central-1 => use AMI finder to identify other images
    itype = "t2.micro"
    publicip = true
    keyname = "ssh_access_key_deployer"
    public_ssh_key = "ssh-rsa AerFRU= abc@def"
    secgroupname = "XY-Security-Group"
  }
}

provider "aws" {
  region = lookup(var.awsprops, "region")
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "default" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route" "defaultroute" {
  route_table_id            = aws_vpc.main.default_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.default.id
  depends_on                = [ aws_internet_gateway.default ]
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_security_group" "project-xy-sg" {
  name = lookup(var.awsprops, "secgroupname")
  description = lookup(var.awsprops, "secgroupname")
  vpc_id = aws_vpc.main.id

  // allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [ aws_vpc.main ]
}

resource "aws_key_pair" "deployer" {
  key_name   = lookup(var.awsprops, "keyname")
  public_key = lookup(var.awsprops, "public_ssh_key")
}


resource "aws_instance" "project-xy" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  subnet_id = aws_subnet.main.id
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  
  key_name = lookup(var.awsprops, "keyname")

  vpc_security_group_ids = [ aws_security_group.project-xy-sg.id ]
  
  root_block_device {
    delete_on_termination = true
    volume_size = 8
    volume_type = "gp2"
  }
  tags = {
    Name ="server01"
    Environment = "dev"
    OS = "Ubuntu"
    Managed = "IAC"
  }

  depends_on = [ aws_security_group.project-xy-sg ]
}

output "ec2instance_ip" {
  value = aws_instance.project-xy.public_ip
}

output "ec2instance_dns" {
  value = aws_instance.project-xy.public_dns
}