# TODO: Designate a cloud provider, region, and credentials

provider "aws" {
  access_key = ""
  secret_key = ""
  region = "us-east-1"
}

data "aws_vpc" "selected" {
  id = "vpc-5e815223"
}

data "aws_subnet" "selected" {
  availability_zone = "us-east-1d"
  id = "subnet-9c1b99bd"
}


# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2

resource "aws_instance" "UdacityT2" {
  count = "4"
  ami = "ami-0323c3dd2da7fb37d"
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.selected.id
  tags = {
    name = "Udacity T2"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4

resource "aws_instance" "UdacityM4" {
  count = "2"
  ami = "ami-0323c3dd2da7fb37d"
  instance_type = "m4.large"
  subnet_id = data.aws_subnet.selected.id
  tags = {
    name = "Udacity M4"
  }
}