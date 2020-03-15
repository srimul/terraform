# Provide need nto be specifed here. But still metioned here for 
# unit testing purpose.
provider "aws" {
   region = "us-east-2"
}

#This code will be moved to module
#terraform {
#  backend "s3" {
#    bucket = "cloudzenixtfstatefiles03012020"
#    #key    = "tfstatefiles/terraform.tfstate"
#    key    = "asg01/terraform.tfstate"
#    region = "us-east-2"
#  }
#}

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

resource "aws_autoscaling_group" "my_asg_01" {
  name                 = "my_asf_${var.env}"
  max_size = "${var.max_count}"
  min_size = "${var.min_count}"
  desired_capacity ="${var.desired_count}"
  health_check_grace_period = "${var.hc_grace_period}"
  launch_configuration = "${var.asgLC}"
  #launch_configuration = "${aws_launch_configuration.my_asc_01.name}"
  wait_for_capacity_timeout = "${var.cap_timeout}"
  vpc_zone_identifier       = ["${var.subnet1}", "${var.subnet2}"]
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

