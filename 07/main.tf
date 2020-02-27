# To Create a Security group 
# Add a tag to the security group
provider "aws" {
  region                  = "${var.region}"
  #shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default"
}

data "aws_ami"  {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "description"
    values = ["Created*"]
  }
}


#output "AMIID"{
#    value = "${data.aws_ami.app_ami.id}"
#}
output "regionname"{
    value = "${var.region}"
}
output "End!!!!!!!!!!!!!!!!!!!"{
    value = "End of Script Execution"
}

