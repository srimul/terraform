variable "region" {
  default = "us-east-2"
}
variable "amiid" {
  default = "ami-0df2ea5740105c299"
  description = "Image Id you have created for Launch"
}
variable "env" {
  type = "string"
  default = "dev"
  description ="Value of this variable is supplied in modules calling"
}
variable "asgLC" {
  type = "string"
  default = "WebServerLC01"
  description ="Value of this variable is supplied in modules calling"
}
variable "min_count" {
  default = "1"
  description = "Minimum number of instance you want to trigger"
}

variable "desired_count" {
  default = "1"
  description = "Desired number of instance you want "
}

variable "max_count" {
  default = "1"
  description = "Maximum number of instance you want"
}
variable "hc_grace_period"{
  default = "180"
  description = " Health Check Grace period"
}
variable "cap_timeout"{
  default = "3m"
  description = "Capacity time out wait "
}
variable "subnet1"{
  default = "subnet-3132df5a"
  description = "Subnet 1"
}
variable "subnet2"{
  default = "subnet-b2aff4c8"
  description = "Subnet 2"
}
variable "subnet3"{
  default = "subnet-46d2500a"
  description = "Subnet 3"
}
variable "instance_count" {
  default = "1"
}
variable "key_name" {
  default = "cZSecurityKey01"
  description = "the ssh key to be used for the EC2 instance"
}

variable "security_group" {
  default = "sg-00b9ae4e6956942bc"
  description = "Security groups for the instance"
}
