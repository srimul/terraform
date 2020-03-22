This module is create ASG in differnet enviroments listed under envs directory.
This code is test on terraform 0.11.11
'modules' directory has code for the modules in referenced in each of the environment.
'envs' directory has list of environments (prod, test, dev) you may want to spin the infrastructure for.
To chanage the values for an environements, you may edit the variables.tf file in that enviroment  with appropriate values
This code reference Auto Scaling Laucnh Config : "WebServerLC01".
If you do not have such a Auto Scaliong Config Lauch ... you may create the reosurce with the following block:
------------------------ START ---------------------------------
resource "aws_launch_configuration" "my_asc_01" {
  name = "WebServerLC01"
  # Repalce with you amiid 
  image_id = "${var.amiid}"
  #Reaplce the sg with your sg
  security_groups = ["sg-00b9ae4e6956942bc"]
  instance_type = "t2.micro"
  #Replace the key name wity yout key file name
  key_name = "${var.key_name}" 
}
------------------------- END ------------------------------------
To use this code:
1. Clone the code
2. To create infera in prod environment Goto moduleASG/envs/prod and edit variables.tf file if needed 
3. terrraform init
4. terraform validate
5. terraform paln
5. terraform apply -auto-approve
