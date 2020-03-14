# Using aws terraform provider
provider "aws" {
   region = "us-east-2"
}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "remote-state" {
  backend = "s3"
  config {
    #bucket     = "${var.tf_state_bucket}"
    bucket = "cloudzenixtfstatefiles03012020"
    #lock_table = "${var.tf_state_table}"
    region     = "us-east-2"
    key        = "dev"
  }
}


# Create a VPC usgin vpcModule and display its Id
module "dev-vpc" {
    source = "../../vpcModule"
    vpc_cidrblk = "${var.vpc_cidrblk}"
    env = "${var.env}"
}

#resource "aws_vpc" "myvpc1" {
#  cidr_block = "${var.vpc_cidrblk}"
 
#  tags = {
#    Name = "vpc-env-${var.env}"
#  }
#}

#output "VPC id" {
#  value = "${aws_vpc.myvpc.id}"
#}

# Gather date about the call of the program and display values

data "aws_caller_identity" "current" {}
output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "caller_arn" {
  value = "${data.aws_caller_identity.current.arn}"
}

output "caller_user" {
  value = "${data.aws_caller_identity.current.user_id}"
}
