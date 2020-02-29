# To create  S3 bucket 

provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "/home/ubuntu/.aws/credentials"
  profile                 = "default"
}


data "aws_instance" "myinstance" {
  instance_id = "i-0228a243b52f122c6"
}


#instance_state

output "EC2 Instnace root  Volume" {
    value = "${data.aws_instance.myinstance.root_block_device[0]}"
}

output "EC2 Instnace details" {
    value = "${data.aws_instance.myinstance.instance_state}"
}

output "End of Script" {
    value = "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
}

