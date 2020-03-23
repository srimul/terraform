# Specify the provider and access details
provider "aws" {
#Muni: It would better to keep the credentails away from the code.
#Muni: You may them in a separte file or export these from command line. 
  region = "${var.aws_region}"
}
#creates tfstate file in S3 bucket cloudzenixtfstatefiles03012020 
terraform {
  backend "s3" {
    bucket = "cloudzenixtfstatefiles03012020"
    key    = "muni01/terraform.tfstate"
    region = "us-east-2"
  }
}
#creates VPC-A with cidr 10.0.0.0/16
resource "aws_vpc" "VPC-A" {
  cidr_block = "10.0.0.0/16"
}
# creates VPC-B with cidr 20.0.0.0/16
resource "aws_vpc" "VPC-B" {
  cidr_block = "20.0.0.0/16"
}

# creates internet gateway to access VPC-A subnets
resource "aws_internet_gateway" "mygateway01" {
  vpc_id = "${aws_vpc.VPC-A.id}"
}

#Adding the internetgateway id to VPC-A main routing tables 
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.VPC-A.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.mygateway01.id}"
}

#Creates a subnet under VPC-A
resource "aws_subnet" "subnet-vpc-a" {
  vpc_id                  = "${aws_vpc.VPC-A.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

#Creates a subnet under VPC-B
resource "aws_subnet" "subnet-vpc-b" {
  vpc_id                  = "${aws_vpc.VPC-B.id}"
  cidr_block              = "20.0.1.0/24"
}


#Datasource to get the caller identity details
data "aws_caller_identity" "main" {
  provider = "aws"
}
#Initiates peering connection between VPC-A and VPC-B with account ID
#VPC-A sends a peering request to VPC-B
resource "aws_vpc_peering_connection" "main" {
  vpc_id        = "${aws_vpc.VPC-A.id}"
  peer_vpc_id   = "${aws_vpc.VPC-B.id}"
  peer_owner_id = "${data.aws_caller_identity.main.account_id}"
  peer_region   = "us-east-2"
  auto_accept   = false

  tags = {
    Side = "Requester"
  }
}

#VPC-B accepts the peering request
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = "aws"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.main.id}"
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}


#Creates a security group for VPC-A with 22 and 80 open

resource "aws_security_group" "subnet-vpc-a-sg" {
  name        = "subnet-vpc-a-sg for peer testing"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.VPC-A.id}"

  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  ingress {
    from_port   = -1
    to_port     = -1 
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 80
    to_port     = 80
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

#Creates a security group for VPC-B with 22 and 80 open

resource "aws_security_group" "subnet-vpc-b-sg" {
  name        = "subnet-vpc-b-sg For peering test"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.VPC-B.id}"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  ingress {
    from_port   = -1
    to_port     = -1 
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#outbound rule for security group
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#gets the key name and key file from variables.tf file
resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}
#creating the instance with VPC-A 
resource "aws_instance" "vpc-a-instance" {


  connection { #haven't understood this block

    user = "ubuntu"
    host = "${self.public_ip}"

  }

  instance_type = "t2.micro"



  ami = "${lookup(var.aws_amis, var.aws_region)}"


  key_name = "${aws_key_pair.auth.id}"


  vpc_security_group_ids = ["${aws_security_group.subnet-vpc-a-sg.id}"]




  subnet_id = "${aws_subnet.subnet-vpc-a.id}"




  tags {
    Name = "VPC-A-Inst01"
  }
}
# creating instance on VPC-B
resource "aws_instance" "vpc-b-instance" {


  connection {

    user = "ubuntu"
    host = "${self.public_ip}"

  }

  instance_type = "t2.micro"



  ami = "${lookup(var.aws_amis, var.aws_region)}"


  key_name = "${aws_key_pair.auth.id}"


  vpc_security_group_ids = ["${aws_security_group.subnet-vpc-b-sg.id}"]




  subnet_id = "${aws_subnet.subnet-vpc-b.id}"




  tags {
    Name = "VPC-B-Inst01"
  }
}
