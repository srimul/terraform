# To Create a Security group
provider "aws" {
  region                  = "${var.region}"
  #shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default"
}

terraform {
  backend "s3" {
    bucket = "cloudzenixtfstatefiles03012020"
    #key    = "tfstatefiles/terraform.tfstate"
    key    = "project2/terraform.tfstate"
    region = "us-east-2"
  }
}

resource "aws_security_group" "allow_ssh" {
  name = "sg01FromTfModifiedS3Backend"
  description = "Allow ssh inbound traffic"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["9.0.0.0/8"]
  }

}

output "SecurityGroupId" {
    value = "${aws_security_group.allow_ssh.id}"
}

output "regionname"{
    value = "${var.region}"
}
output "SampelString"{
    value = "Hello World!"
}

