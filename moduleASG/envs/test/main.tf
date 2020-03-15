provider "aws" {
   region = "us-east-2"
}

#This code is needed in the calling module.
terraform {
  backend "s3" {
    bucket = "cloudzenixtfstatefiles03012020"
    #key    = "tfstatefiles/terraform.tfstate"
    key    = "asgMod/test/terraform.tfstate"
    region = "us-east-2"
  }
}

#resource "aws_launch_configuration" "my_asc_01" {
#  name = "my-asc-1"
#  image_id = "${var.amiid}"
#  security_groups = ["sg-00b9ae4e6956942bc"]
#  instance_type = "t2.micro"
#  # Other params are not defined here because, image we are using has all that info.
#  #user_data = "${file("user-data.txt")}"
#}
## Belwo output statement is to expose ASG Launch config through module
## This is a way to return values from a modules
#output "asgL_config" {
#  value = "${aws_launch_configuration.my_asc_01.name}"  
#}

#resource "aws_autoscaling_group" "my_asg_01" {
module  "test-ASG-01" {
  source = "../../modules/asg"
  env    = "${var.env}"
  max_count = "${var.max_count}"
  min_count = "${var.min_count}"
  desired_count = "${var.desired_count}"
  hc_grace_period = "${var.hc_grace_period}"
  asgLC = "${var.asgLC}"
  #launch_configuration = "${aws_launch_configuration.my_asc_01.name}"
  cap_timeout = "${var.cap_timeout}"
  subnet1 = "${var.subnet1}"
  subnet2 = "${var.subnet2}"
}

#output "Auto_Scaling_Group_ID:" {
#  value = "${aws_autoscaling_group.my_asg_01.id}"
#}

#output "Auto_Scaling_Launch_Config_ID:" {
#  value = "${aws_launch_configuration.my_asc_01.id}"
#}

#output "Auto_Scaling_Launch_Config_ARN:" {
#  value = "${aws_launch_configuration.my_asc_01.arn}"
#}


#output "End_of_the_Script" {
#  value = "End of Script"
#}

