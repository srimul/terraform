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
    key        = "sample"
  }
}


# Create a VPC usgin vpcModule and display its Id
module "prod-vpc" {
    source = "../../vpcModule"
    vpc_cidrblk = "${var.vpc_cidrblk}"
    env = "${var.env}"
}

output "VPC created is " {
     value = "${module.prod-vpc.VPC_id}"
}

