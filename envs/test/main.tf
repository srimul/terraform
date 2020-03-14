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
    bucket = "cloudzenixtfstatefiles03012020"
    region     = "us-east-2"
    key        = "test"
  }
}


# Create a VPC usgin vpcModule and display its Id
module "test-vpc" {
    source = "../../vpcModule"
    vpc_cidrblk = "${var.vpc_cidrblk}"
    env = "${var.env}"
}

output "VPC created is " {
     value = "${module.test-vpc.VPC_id}"
}

