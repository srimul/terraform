# Create a VPC and display its Id
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
 
  tags = {
    Name = "vpCreatedFromTf01"
  }
}

output "VPC id" {
  value = "${aws_vpc.myvpc.id}"
}

# Gather date about the call of the program and display values

data "aws_caller_identity" "current" {}
output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "caller_arn" {
  value = "${data.aws_caller_identity.current.arn}"
}

output "caller_user" {
  value = "${data.aws_caller_identity.current.user_id}"
}




