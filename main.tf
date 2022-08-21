terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "tf-nginx-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project-name}-vpc"
  }
}

resource "aws_internet_gateway" "tf-nginx-igw" {
  vpc_id = aws_vpc.tf-nginx-vpc.id

  tags = {
    Name = "${var.project-name}-igw"
  }
}

resource "aws_subnet" "tf-nginx-subnet" {
  vpc_id                  = aws_vpc.tf-nginx-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project-name}-subnet"
  }
}

resource "aws_route_table" "pulic-rt" {
  vpc_id = aws_vpc.tf-nginx-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-nginx-igw.id
  }

  tags = {
    Name = "${var.project-name}-public-route-table"
  }
}

resource "aws_route_table_association" "tf-nginx-subnet-rt-association" {
  subnet_id      = aws_subnet.tf-nginx-subnet.id
  route_table_id = aws_route_table.pulic-rt.id
}

resource "aws_security_group" "tf-nginx-sg" {
  name   = "${var.project-name}-sg"
  vpc_id = aws_vpc.tf-nginx-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "tf-nginx-server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.tf-nginx-subnet.id
  vpc_security_group_ids      = [aws_security_group.tf-nginx-sg.id]
  user_data                   = file("scripts/nginx.sh")
  user_data_replace_on_change = true

  tags = {
    Name = var.instance_name
  }
}
