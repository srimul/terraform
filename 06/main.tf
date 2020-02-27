# To Create a Security group 
# Add a tag to the security group
provider "aws" {
  region                  = "${var.region}"
  #shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default"
}

resource "aws_security_group" "allow_ssh" {
  name = "sg01FromTfModified"
  description = "Allow ssh inbound traffic"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
     Name = "sshPort22SecGroup"
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

