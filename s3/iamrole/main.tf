# To create  S3 bucket 

provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "/home/ubuntu/.aws/credentials"
  profile                 = "default"
}


data "aws_iam_user" "myuser" {
  user_name = "myuser1"
  #user_name = "ec2user"
}

resource "aws_iam_user" "tfuser1" {
  name = "tfuser1"
  #name = "myuser1" # uncomment this line to show the failing condition

  tags = {
    tag-key = "tfUser01"
  }
}

output "NewUser arn" {
    value = "${aws_iam_user.tfuser1.arn}"
}

output "User arn" {
    value = "${data.aws_iam_user.myuser.arn}"
}

output "End of Script" {
    value = "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
}

