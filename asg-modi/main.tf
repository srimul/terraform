provider "aws" {
   region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "cloudzenixtfstatefiles03012020"
    #key    = "tfstatefiles/terraform.tfstate"
    key    = "asg02/terraform.tfstate"
    region = "us-east-2"
  }
}

resource "aws_launch_configuration" "my_asc_01" {
  name = "my-asc-1"
  image_id = "${var.amiid}"
  security_groups = ["sg-00b9ae4e6956942bc"]
  instance_type = "t2.micro"
  key_name = "${var.key_name}" 
  # Other params are not defined here because, image we are using has all that info.
  #user_data = "${file("user-data.txt")}"
}

resource "aws_autoscaling_group" "my_asg_01" {
  name                 = "my_asf_tf_01"
  max_size = "${var.max_count}"
  min_size = "${var.min_count}"
  desired_capacity ="${var.desired_count}"
  health_check_grace_period = "${var.hc_grace_period}"
  launch_configuration = "${aws_launch_configuration.my_asc_01.name}"
  wait_for_capacity_timeout = "${var.cap_timeout}"
  vpc_zone_identifier       = ["${var.subnet1}", "${var.subnet2}"]
}

output "Auto Scaling Group ID:" {
  value = "${aws_autoscaling_group.my_asg_01.id}"
}

output "Auto Scaling Launch Config ID:" {
  value = "${aws_launch_configuration.my_asc_01.id}"
}

output "Auto Scaling Launch Config ARN:" {
  value = "${aws_launch_configuration.my_asc_01.arn}"
}


output "End of the Script" {
  value = "End of Script"
}

