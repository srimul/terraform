# Specify the provider and access details
provider "aws" {
#Muni: It would better to keep the credentails away from the code.
#Muni: You may them in a separte file or export these from command line. 
  region = "${var.aws_region}"
}
terraform {
  backend "s3" {
    bucket = "cloudzenixtfstatefiles03012020"
    key    = "muni01/terraform.tfstate"
    region = "us-east-2"
  }
}
# Create a VPC to launch our instances into
resource "aws_vpc" "VPC-A" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_vpc" "VPC-B" {
  cidr_block = "20.0.0.0/16"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "mygateway01" {
  vpc_id = "${aws_vpc.VPC-A.id}"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.VPC-A.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.mygateway01.id}"
}

# Create a subnet in VPC-A to launch our instances into
resource "aws_subnet" "subnet-vpc-a" {
  vpc_id                  = "${aws_vpc.VPC-A.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Create a subnet in VPC-B to launch our instances into
resource "aws_subnet" "subnet-vpc-b" {
  vpc_id                  = "${aws_vpc.VPC-B.id}"
  cidr_block              = "20.0.1.0/24"
}

# To get the account id of the VPC Owner.

data "aws_caller_identity" "main" {
  provider = "aws"
}
# Requester's side of the connection.
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

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = "aws"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.main.id}"
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}


# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "subnet-vpc-a-sg" {
  name        = "subnet-vpc-a-sg for peer testing"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.VPC-A.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ICMP access from anywhere
  ingress {
    from_port   = -1
    to_port     = -1 
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "subnet-vpc-b-sg" {
  name        = "subnet-vpc-b-sg For peering test"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.VPC-B.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # ICMP access from anywhere
  ingress {
    from_port   = -1
    to_port     = -1 
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "vpc-a-instance" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "ubuntu"
    host = "${self.public_ip}"
    # The connection will use the local SSH agent for authentication.
  }

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair we created above.
  key_name = "${aws_key_pair.auth.id}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.subnet-vpc-a-sg.id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = "${aws_subnet.subnet-vpc-a.id}"

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  tags {
    Name = "VPC-A-Inst01"
  }
}

resource "aws_instance" "vpc-b-instance" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "ubuntu"
    host = "${self.public_ip}"
    # The connection will use the local SSH agent for authentication.
  }

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair we created above.
  key_name = "${aws_key_pair.auth.id}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.subnet-vpc-b-sg.id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = "${aws_subnet.subnet-vpc-b.id}"

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  tags {
    Name = "VPC-B-Inst01"
  }
}
